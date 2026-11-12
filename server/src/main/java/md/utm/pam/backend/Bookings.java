// Bookings: T17 entity scoped per user — Notes.java with other nouns.
//
// Same pattern as notes: list with pagination/search, create with validation
// (400), get/put/delete with 404 — plus 409 when the slot is already taken.
// Someone else's booking is indistinguishable from a missing one (404).

package md.utm.pam.backend;

import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/bookings")
public class Bookings {

	private static final Set<String> STATUSES = Set.of("confirmed", "completed", "cancelled");

	/**
	 * One query shape for every read: the booking with its court and slot
	 * joined in, so the app gets a ready Booking(court, slot) in one response.
	 * c.id is selected AS id so Courts.toJson() can be reused as is.
	 */
	private static final String SELECT = """
			SELECT b.id AS booking_id, b.total_price, b.status, b.created_at,
			       b.slot_id, s.date, s.start_time, s.end_time,
			       c.id, c.name, c.sport, c.district, c.address,
			       c.price_per_hour, c.image_url, c.amenities
			FROM bookings b
			JOIN courts c ON c.id = b.court_id
			JOIN slots  s ON s.id = b.slot_id
			""";

	private final Db db;

	Bookings(Db db) {
		this.db = db;
	}

	/** Maps a joined row to the JSON shape of the Flutter Booking model. */
	private static Map<String, Object> toJson(Map<String, Object> row) {
		String status = (String) row.get("status");
		return Map.of(
				"id", row.get("booking_id"),
				"court", Courts.toJson(row),
				"slot", Map.of(
						"id", row.get("slot_id"),
						"courtId", row.get("id"),
						"date", row.get("date"),
						"startTime", row.get("start_time"),
						"endTime", row.get("end_time"),
						// a confirmed booking holds its slot
						"isAvailable", !status.equals("confirmed")),
				"totalPrice", row.get("total_price"),
				"status", status,
				"createdAt", row.get("created_at"));
	}

	/** Finds a booking by id, but only among the current user's bookings. */
	private Map<String, Object> find(long userId, long id) {
		var rows = db.jdbc.queryForList(
				SELECT + "WHERE b.id = ? AND b.user_id = ?", id, userId);
		if (rows.isEmpty()) throw Errors.notFound("Booking not found");
		return rows.get(0);
	}

	/** True when [slotId] already has a confirmed booking (other than [exceptId]). */
	private boolean slotTaken(long slotId, long exceptId) {
		Integer n = db.jdbc.queryForObject(
				"SELECT COUNT(*) FROM bookings "
						+ "WHERE slot_id = ? AND status = 'confirmed' AND id <> ?",
				Integer.class, slotId, exceptId);
		return n != null && n > 0;
	}

	/** GET /bookings?page=1&limit=20&search=  -> {items, page, limit, total} */
	@GetMapping
	public Map<String, Object> list(@RequestAttribute("userId") long userId,
			@RequestParam(defaultValue = "") String page,
			@RequestParam(defaultValue = "") String limit,
			@RequestParam(defaultValue = "") String search) {
		int pageN = Math.max(parseIntOr(page, 1), 1);
		int limitN = Math.min(Math.max(parseIntOr(limit, 20), 1), 100);

		// search by the court's name or district
		String where = "WHERE b.user_id = ? AND (c.name LIKE ? OR c.district LIKE ?)";
		String like = "%" + search + "%";

		int total = db.jdbc.queryForObject(
				"SELECT COUNT(*) FROM bookings b JOIN courts c ON c.id = b.court_id " + where,
				Integer.class, userId, like, like);
		List<Map<String, Object>> rows = db.jdbc.queryForList(
				SELECT + where + " ORDER BY b.id DESC LIMIT ? OFFSET ?",
				userId, like, like, limitN, (pageN - 1) * limitN);

		return Map.of(
				"items", rows.stream().map(Bookings::toJson).toList(),
				"page", pageN,
				"limit", limitN,
				"total", total);
	}

	/** POST /bookings  {slotId} -> 201 booking | 400 | 409 */
	@PostMapping
	@ResponseStatus(HttpStatus.CREATED)
	public Map<String, Object> create(@RequestAttribute("userId") long userId,
			@RequestBody Map<String, Object> body) {
		if (!(body.get("slotId") instanceof Number slotIdN)) {
			throw Errors.validation("slotId is required");
		}
		long slotId = slotIdN.longValue();

		// the price and the court come from the database, never from the client
		var slots = db.jdbc.queryForList("""
				SELECT s.court_id, c.price_per_hour
				FROM slots s JOIN courts c ON c.id = s.court_id
				WHERE s.id = ?""", slotId);
		if (slots.isEmpty()) throw Errors.validation("slotId does not exist");
		if (slotTaken(slotId, 0)) throw Errors.slotTaken();

		var slot = slots.get(0);
		long id;
		try {
			id = db.insert(
					"INSERT INTO bookings (user_id, court_id, slot_id, total_price, status, created_at) "
							+ "VALUES (?, ?, ?, ?, 'confirmed', ?)",
					userId, slot.get("court_id"), slotId, slot.get("price_per_hour"), Db.nowIso());
		} catch (DataIntegrityViolationException e) {
			throw Errors.slotTaken(); // the unique index caught a race
		}
		return toJson(find(userId, id));
	}

	/** GET /bookings/{id} -> 200 booking | 404 */
	@GetMapping("/{id}")
	public Map<String, Object> get(@RequestAttribute("userId") long userId,
			@PathVariable long id) {
		return toJson(find(userId, id));
	}

	/** PUT /bookings/{id}  {status} -> 200 updated booking | 400 | 404 | 409 */
	@PutMapping("/{id}")
	public Map<String, Object> update(@RequestAttribute("userId") long userId,
			@PathVariable long id, @RequestBody Map<String, Object> body) {
		var current = find(userId, id); // 404 (or someone else's) before anything else
		String status = Errors.stringField(body, "status");
		if (status == null || !STATUSES.contains(status)) {
			throw Errors.validation("status must be confirmed, completed or cancelled");
		}
		// re-confirming a cancelled booking needs the slot to be free again
		long slotId = ((Number) current.get("slot_id")).longValue();
		if (status.equals("confirmed") && slotTaken(slotId, id)) throw Errors.slotTaken();

		try {
			db.jdbc.update("UPDATE bookings SET status = ? WHERE id = ?", status, id);
		} catch (DataIntegrityViolationException e) {
			throw Errors.slotTaken();
		}
		return toJson(find(userId, id));
	}

	/** DELETE /bookings/{id} -> 204 | 404 */
	@DeleteMapping("/{id}")
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void delete(@RequestAttribute("userId") long userId,
			@PathVariable long id) {
		find(userId, id); // 404 before deleting
		db.jdbc.update("DELETE FROM bookings WHERE id = ?", id);
	}

	/** Query params arrive as text; garbage falls back to the default. */
	private static int parseIntOr(String value, int fallback) {
		try {
			return Integer.parseInt(value);
		} catch (NumberFormatException e) {
			return fallback;
		}
	}
}
