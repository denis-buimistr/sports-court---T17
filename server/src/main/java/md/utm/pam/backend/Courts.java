// Courts: T17 catalog entity, copied from the Notes.java pattern.
//
// Differences from notes: courts are SHARED (no user_id — every user sees
// the same catalog), they are read-only through the API and seeded on the
// first start. Sub-route: GET /courts/{id}/slots.

package md.utm.pam.backend;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/courts")
public class Courts {

	/** Working hours: one slot per hour, 08:00 .. 22:00. */
	private static final int OPEN_HOUR = 8;
	private static final int CLOSE_HOUR = 22;

	private final Db db;

	Courts(Db db) {
		this.db = db;
		seedMissing();
	}

	/** Maps a courts row to the JSON shape the Flutter Court model expects. */
	static Map<String, Object> toJson(Map<String, Object> row) {
		String amenities = (String) row.get("amenities");
		return Map.of(
				"id", row.get("id"),
				"name", row.get("name"),
				"sport", row.get("sport"),
				"district", row.get("district"),
				"address", row.get("address"),
				"pricePerHour", row.get("price_per_hour"),
				"imageUrl", row.get("image_url"),
				// SQLite has no arrays: stored as "a,b,c", sent as ["a","b","c"]
				"amenities", amenities.isEmpty()
						? List.of()
						: Arrays.asList(amenities.split(",")));
	}

	/** Maps a slots row (+ computed "taken" column) to JSON. */
	static Map<String, Object> slotToJson(Map<String, Object> row) {
		return Map.of(
				"id", row.get("id"),
				"courtId", row.get("court_id"),
				"date", row.get("date"),
				"startTime", row.get("start_time"),
				"endTime", row.get("end_time"),
				"isAvailable", ((Number) row.get("taken")).intValue() == 0);
	}

	/** Finds a court by id or throws 404. */
	Map<String, Object> find(long id) {
		var rows = db.jdbc.queryForList("SELECT * FROM courts WHERE id = ?", id);
		if (rows.isEmpty()) throw Errors.notFound("Court not found");
		return rows.get(0);
	}

	/** GET /courts?page=1&limit=20&search=  -> {items, page, limit, total} */
	@GetMapping
	public Map<String, Object> list(
			@RequestParam(defaultValue = "") String page,
			@RequestParam(defaultValue = "") String limit,
			@RequestParam(defaultValue = "") String search) {
		int pageN = Math.max(parseIntOr(page, 1), 1);
		int limitN = Math.min(Math.max(parseIntOr(limit, 20), 1), 100);

		// search looks at the name, the district and the address.
		// SQLite's LIKE ignores case only for Latin letters ("центр" would not
		// find "Центр"), so the small catalog is filtered here with Java's
		// Unicode-aware toLowerCase, then cut into the requested page.
		String needle = search.trim().toLowerCase(Locale.ROOT);
		List<Map<String, Object>> matching = db.jdbc
				.queryForList("SELECT * FROM courts ORDER BY id").stream()
				.filter(r -> needle.isEmpty()
						|| (r.get("name") + " " + r.get("district") + " " + r.get("address"))
								.toLowerCase(Locale.ROOT).contains(needle))
				.toList();
		int total = matching.size();
		int from = Math.min((pageN - 1) * limitN, total);
		List<Map<String, Object>> rows = matching.subList(from, Math.min(from + limitN, total));

		return Map.of(
				"items", rows.stream().map(Courts::toJson).toList(),
				"page", pageN,
				"limit", limitN,
				"total", total);
	}

	/** GET /courts/{id} -> 200 court | 404 */
	@GetMapping("/{id}")
	public Map<String, Object> get(@PathVariable long id) {
		return toJson(find(id));
	}

	/**
	 * GET /courts/{id}/slots?date=YYYY-MM-DD (default: today) -> 200 [slot]
	 * Slots of a day are created on first request, so any date is bookable.
	 */
	@GetMapping("/{id}/slots")
	public List<Map<String, Object>> slots(@PathVariable long id,
			@RequestParam(defaultValue = "") String date) {
		find(id); // 404 for an unknown court before anything else
		String day = parseDateOr400(date);
		ensureSlots(id, day);

		return db.jdbc.queryForList("""
				SELECT s.*,
				       EXISTS (SELECT 1 FROM bookings b
				               WHERE b.slot_id = s.id AND b.status = 'confirmed') AS taken
				FROM slots s
				WHERE s.court_id = ? AND s.date = ?
				ORDER BY s.start_time""", id, day)
				.stream().map(Courts::slotToJson).toList();
	}

	/**
	 * PUT /courts/{id}/image  {imageUrl: "/files/7"} -> 200 court | 400 | 404
	 * L5 task 7: the photo is uploaded first to POST /files, then its
	 * relative url is stored on the court.
	 */
	@PutMapping("/{id}/image")
	public Map<String, Object> setImage(@PathVariable long id,
			@RequestBody Map<String, Object> body) {
		find(id); // 404 first
		String url = Errors.stringField(body, "imageUrl");
		if (url == null || !url.matches("/files/\\d+")) {
			throw Errors.validation("imageUrl must look like /files/{id}");
		}
		db.jdbc.update("UPDATE courts SET image_url = ? WHERE id = ?", url, id);
		return toJson(find(id));
	}

	/** Inserts the hourly slots of [day] once; UNIQUE makes repeats no-ops. */
	private void ensureSlots(long courtId, String day) {
		for (int h = OPEN_HOUR; h < CLOSE_HOUR; h++) {
			db.jdbc.update(
					"INSERT OR IGNORE INTO slots (court_id, date, start_time, end_time) "
							+ "VALUES (?, ?, ?, ?)",
					courtId, day, hour(h), hour(h + 1));
		}
	}

	private static String hour(int h) {
		return String.format("%02d:00", h);
	}

	/** "" -> today; a valid ISO date -> itself; anything else -> 400. */
	private static String parseDateOr400(String date) {
		if (date.isEmpty()) return LocalDate.now().toString();
		try {
			return LocalDate.parse(date).toString();
		} catch (DateTimeParseException e) {
			throw Errors.validation("date must be YYYY-MM-DD");
		}
	}

	/** Query params arrive as text; garbage falls back to the default. */
	private static int parseIntOr(String value, int fallback) {
		try {
			return Integer.parseInt(value);
		} catch (NumberFormatException e) {
			return fallback;
		}
	}

	// -----------------------------------------------------------------------
	// Seed: the 8 courts of the Flutter mock (L2-L4) + 16 more for paging.
	// -----------------------------------------------------------------------

	/**
	 * Inserts every seed court that is not in the table yet (matched by name),
	 * so an app.db created with the first 8 courts receives the new ones too.
	 * 24 courts > one page of 20: pagination has something to show (task 6).
	 */
	private void seedMissing() {
		Object[][] courts = {
				{"Arena Dacia", "football", "Ботаника", "бул. Дачия, 45", 400,
						"Искусственный газон,Освещение,Раздевалки,Душ"},
				{"Green Field Buiucani", "football", "Буюканы", "ул. Албишоара, 78", 350,
						"Искусственный газон,Освещение,Трибуны"},
				{"Tennis Club Centru", "tennis", "Центр", "ул. Букурешть, 12", 180,
						"Грунтовые корты,Аренда ракеток,Тренер по запросу"},
				{"Ace Tennis Academy", "tennis", "Рышкановка", "ул. Каля Орхеюлуй, 33", 200,
						"Крытый корт,Душ,Парковка"},
				{"Basket Zone", "basketball", "Чеканы", "бул. Мирча чел Бэтрын, 21", 220,
						"Крытый зал,Кондиционер,Раздевалки"},
				{"Dunk City", "basketball", "Центр", "ул. Измаил, 54", 260,
						"Паркет,Табло,Парковка"},
				{"Sand & Net Volleyball", "volleyball", "Телецентр", "ул. Дечебал, 80", 150,
						"Песчаное покрытие,Душ,Аренда мяча"},
				{"Arena Telecentru", "football", "Телецентр", "бул. Траян, 9", 320,
						"Искусственный газон,Освещение,Трибуны,Раздевалки"},
				{"Riscani Football Park", "football", "Рышкановка", "ул. Миорица, 5", 300,
						"Искусственный газон,Освещение"},
				{"Ciocana Arena", "football", "Чеканы", "ул. Ино Москова, 17", 280,
						"Искусственный газон,Раздевалки,Парковка"},
				{"Botanica Sport Hall", "basketball", "Ботаника", "ул. Сарматическая, 92", 210,
						"Крытый зал,Раздевалки,Душ"},
				{"Valea Morilor Courts", "tennis", "Центр", "ул. Александр Пушкин, 60", 190,
						"Хард,Освещение,Аренда ракеток"},
				{"Lake Beach Volley", "volleyball", "Буюканы", "парк Ла Извор", 140,
						"Песчаное покрытие,Аренда мяча"},
				{"Telecentru Tennis", "tennis", "Телецентр", "ул. Миорица, 1", 170,
						"Грунтовые корты,Парковка"},
				{"Hoops Buiucani", "basketball", "Буюканы", "ул. Ион Крянгэ, 40", 230,
						"Паркет,Табло,Кондиционер"},
				{"Mini Football Centru", "football", "Центр", "ул. Штефан чел Маре, 150", 360,
						"Искусственный газон,Освещение,Душ"},
				{"Ciocana Volley Club", "volleyball", "Чеканы", "бул. Мирча чел Бэтрын, 4", 160,
						"Крытый зал,Аренда мяча"},
				{"Riscani Tennis Point", "tennis", "Рышкановка", "ул. Киев, 12", 185,
						"Хард,Душ"},
				{"Botanica Futsal", "football", "Ботаника", "бул. Траян, 23", 310,
						"Паркет,Раздевалки"},
				{"Streetball Park", "basketball", "Телецентр", "ул. Узинелор, 8", 120,
						"Открытая площадка,Освещение"},
				{"Sky Tennis Club", "tennis", "Буюканы", "ул. Василе Лупу, 31", 240,
						"Крытый корт,Тренер по запросу,Парковка"},
				{"Central Sport Arena", "football", "Центр", "ул. Тигина, 2", 450,
						"Искусственный газон,Трибуны,Табло,Душ"},
				{"Volley Botanica", "volleyball", "Ботаника", "ул. Мунчешть, 120", 155,
						"Крытый зал,Раздевалки"},
				{"Ciocana Hoops", "basketball", "Чеканы", "ул. Петру Заднипру, 9", 200,
						"Паркет,Парковка"},
		};
		for (Object[] c : courts) {
			Integer exists = db.jdbc.queryForObject(
					"SELECT COUNT(*) FROM courts WHERE name = ?", Integer.class, c[0]);
			if (exists != null && exists > 0) continue;
			db.insert("INSERT INTO courts (name, sport, district, address, price_per_hour, amenities) "
					+ "VALUES (?, ?, ?, ?, ?, ?)", c);
		}
	}
}
