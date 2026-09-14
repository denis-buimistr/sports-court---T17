
# SportsCourt

Mobile app for booking sports courts (football, tennis, basketball) — course project for **PAM** (Programarea Aplicațiilor Mobile), UTM / FCIM.

| | |
|---|---|
| **Student** | Buimistr Denis |
| **Group** | CR-233 |
| **Domain** | Sport / Services |
| **Client** | Flutter (Dart), target platform: iOS |
| **Server** | Java, Spring Boot |

---

## Why this app

Booking a football or tennis court usually still means calling the venue and hoping the slot is actually free. There's no shared calendar, so two people can "confirm" the same hour by phone, and a regular team has no easy way to see its own booking history. SportsCourt replaces the phone call with a simple flow: pick a court, pick a free slot, confirm — done.

**Target users:** amateur teams and groups of friends who play on a weekly basis.

## Core user flow

```
Login/Register → Court list (search + filter)
              → Court card (photos, price/hour, amenities)
              → Pick a day → see free time slots
              → Confirm booking (summary + total)
              → My bookings (upcoming / past, cancel)
```

## Screens

1. Login / Register
2. Court list — search + filter by sport type and district
3. Court card — photos, price per hour, amenities
4. Time slot picker — day view with available/booked slots
5. Booking confirmation — summary and final price
6. My bookings — upcoming and past, with cancellation
7. Profile

## Data model (backend)

```
Court     (id, name, sport, address, pricePerHour, imageUrl)
TimeSlot  (id, courtId, date, startTime, endTime, isAvailable)
Booking   (id, timeSlotId, userId, totalPrice, status, createdAt)
```

**Main endpoints:** `GET/POST /courts`, `GET/PUT/DELETE /courts/{id}`, `GET/POST /time-slots`, `GET/PUT/DELETE /time-slots/{id}`, `GET/POST /bookings`, `GET/PUT/DELETE /bookings/{id}`, `POST /auth/register`, `POST /auth/login`.

## Stack

| Layer | Tools |
|---|---|
| UI | Flutter, Material 3 |
| Navigation | go_router |
| State | Provider / Riverpod *(final choice pending)* |
| Local data | Repository pattern, mock data before backend is ready |
| Backend | Spring Boot, Spring Data JPA, PostgreSQL |
| Auth | Spring Security + JWT |
| Tooling | IntelliJ IDEA (backend), VS Code / IntelliJ + Flutter plugin (client) |
| Versioning | Git / GitHub |

## Nice-to-have (if time allows)

- Recurring weekly bookings (same slot every week)
- Inviting teammates to a booking
- Courts shown on a map

## Progress

| Stage | Status | What it delivers |
|---|---|---|
| L1 | ✅ | Topic chosen, spec written (this README) |
| L2 | ⬜ | Static UI: court list, court card, time slots |
| L3 | ⬜ | Navigation (go_router) + form validation |
| L4 | ⬜ | State management + Repository with mock data |
| L5 | ⬜ | Real backend (Spring Boot) + JWT auth |
| L6 | ⬜ | Offline cache, tests, release build |
