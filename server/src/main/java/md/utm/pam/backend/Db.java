// SQLite setup. app.db is created automatically on first start.
//
// To add your own entity: add a CREATE TABLE below, then copy the pattern
// of Notes.java for its routes.

package md.utm.pam.backend;

import java.sql.Statement;
import java.time.Instant;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.stereotype.Component;

@Component
public class Db {

	/** Parameterized SQL everywhere — visible queries, no ORM in between. */
	final JdbcTemplate jdbc;

	/** Opens the database and applies the schema (idempotent) at startup. */
	Db(JdbcTemplate jdbc) {
		this.jdbc = jdbc;
		jdbc.execute("""
				CREATE TABLE IF NOT EXISTS users (
				  id            INTEGER PRIMARY KEY AUTOINCREMENT,
				  email         TEXT    NOT NULL UNIQUE,
				  password_hash TEXT    NOT NULL,
				  name          TEXT    NOT NULL,
				  created_at    TEXT    NOT NULL
				)""");
		jdbc.execute("""
				CREATE TABLE IF NOT EXISTS notes (
				  id         INTEGER PRIMARY KEY AUTOINCREMENT,
				  user_id    INTEGER NOT NULL REFERENCES users (id),
				  title      TEXT    NOT NULL,
				  content    TEXT    NOT NULL DEFAULT '',
				  created_at TEXT    NOT NULL
				)""");
		// --- T17 SportsCourt entities -------------------------------------
		// Order matters: a table can only REFERENCE one created before it.

		// Courts are a shared catalog (no user_id), seeded in Courts.java.
		jdbc.execute("""
				CREATE TABLE IF NOT EXISTS courts (
				  id             INTEGER PRIMARY KEY AUTOINCREMENT,
				  name           TEXT    NOT NULL,
				  sport          TEXT    NOT NULL,
				  district       TEXT    NOT NULL,
				  address        TEXT    NOT NULL,
				  price_per_hour REAL    NOT NULL,
				  image_url      TEXT    NOT NULL DEFAULT '',
				  amenities      TEXT    NOT NULL DEFAULT ''
				)""");
		// Hourly slots of a court; "taken" is not stored, it is derived from
		// confirmed bookings (one source of truth).
		jdbc.execute("""
				CREATE TABLE IF NOT EXISTS slots (
				  id         INTEGER PRIMARY KEY AUTOINCREMENT,
				  court_id   INTEGER NOT NULL REFERENCES courts (id),
				  date       TEXT    NOT NULL,
				  start_time TEXT    NOT NULL,
				  end_time   TEXT    NOT NULL,
				  UNIQUE (court_id, date, start_time)
				)""");
		// Bookings belong to a user, exactly like notes.
		jdbc.execute("""
				CREATE TABLE IF NOT EXISTS bookings (
				  id          INTEGER PRIMARY KEY AUTOINCREMENT,
				  user_id     INTEGER NOT NULL REFERENCES users (id),
				  court_id    INTEGER NOT NULL REFERENCES courts (id),
				  slot_id     INTEGER NOT NULL REFERENCES slots (id),
				  total_price REAL    NOT NULL,
				  status      TEXT    NOT NULL,
				  created_at  TEXT    NOT NULL
				)""");
		// Safety net under the 409 check in Bookings.java: the database itself
		// refuses a second confirmed booking of the same slot.
		jdbc.execute("""
				CREATE UNIQUE INDEX IF NOT EXISTS one_confirmed_booking_per_slot
				  ON bookings (slot_id) WHERE status = 'confirmed'""");

		jdbc.execute("""
				CREATE TABLE IF NOT EXISTS files (
				  id         INTEGER PRIMARY KEY AUTOINCREMENT,
				  user_id    INTEGER NOT NULL REFERENCES users (id),
				  name       TEXT    NOT NULL,
				  mime_type  TEXT    NOT NULL,
				  size       INTEGER NOT NULL,
				  path       TEXT    NOT NULL,
				  created_at TEXT    NOT NULL
				)""");
	}

	/** Runs an INSERT and returns the generated (AUTOINCREMENT) row id. */
	long insert(String sql, Object... args) {
		var keyHolder = new GeneratedKeyHolder();
		jdbc.update(con -> {
			var ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			for (int i = 0; i < args.length; i++) {
				ps.setObject(i + 1, args[i]);
			}
			return ps;
		}, keyHolder);
		return keyHolder.getKey().longValue();
	}

	/** Current UTC time in ISO-8601 — the format used for all timestamps. */
	static String nowIso() {
		return Instant.now().toString();
	}
}
