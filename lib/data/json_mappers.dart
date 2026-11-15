import '../models/booking.dart';
import '../models/court.dart';
import '../models/time_slot.dart';

// JSON boundary (L5): fromJson / toJson for the domain entities.
// It lives in data/, next to the http repositories, so the entity files in
// lib/models stay exactly as they were on L4 (proof: git diff --stat).
//
// Two conversions happen here and nowhere else:
//  - the server's ids are int, the app has used String ids since L2;
//  - the server speaks ISO dates ("2026-11-20"), screens show "Пт, 20 ноя".
// A body outside the contract throws FormatException / TypeError here,
// and the repository catches it as layer 3.

// [baseUrl]: the server stores the photo as a RELATIVE url ("/files/7");
// the app gets a full one, so Image.network needs nothing else
Court courtFromJson(Map<String, dynamic> j, {String baseUrl = ''}) => Court(
      id: '${j['id'] as int}',
      name: j['name'] as String,
      sport: _byName(Sport.values, j['sport'] as String),
      district: j['district'] as String? ?? '',
      address: j['address'] as String? ?? '',
      pricePerHour: (j['pricePerHour'] as num).toDouble(), // 400 may come as int
      imageUrl: _absolute(j['imageUrl'] as String? ?? '', baseUrl),
      amenities: (j['amenities'] as List? ?? const []).cast<String>(),
    );

TimeSlot timeSlotFromJson(Map<String, dynamic> j) => TimeSlot(
      id: '${j['id'] as int}',
      courtId: '${j['courtId'] as int}',
      date: _displayDate(j['date'] as String),
      startTime: j['startTime'] as String,
      endTime: j['endTime'] as String,
      isAvailable: j['isAvailable'] as bool,
    );

// the server sends a booking with its court and slot joined in
Booking bookingFromJson(Map<String, dynamic> j, {String baseUrl = ''}) => Booking(
      id: '${j['id'] as int}',
      court: courtFromJson(j['court'] as Map<String, dynamic>, baseUrl: baseUrl),
      slot: timeSlotFromJson(j['slot'] as Map<String, dynamic>),
      totalPrice: (j['totalPrice'] as num).toDouble(),
      status: _byName(BookingStatus.values, j['status'] as String),
    );

extension BookingJson on Booking {
  // without id — the identity comes from the server (C8).
  // POST /bookings reads slotId (court and price are decided by the server),
  // PUT /bookings/{id} reads status.
  Map<String, dynamic> toJson() => {
        'slotId': int.parse(slot.id),
        'status': status.name,
      };
}

String _absolute(String url, String baseUrl) =>
    url.startsWith('/') ? '$baseUrl$url' : url;

// an unknown enum value is a body outside the contract
T _byName<T extends Enum>(List<T> values, String name) => values.firstWhere(
      (v) => v.name == name,
      orElse: () => throw FormatException('Unknown value: $name'),
    );

const _weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
const _months = [
  'янв', 'фев', 'мар', 'апр', 'мая', 'июн',
  'июл', 'авг', 'сен', 'окт', 'ноя', 'дек',
];

String _displayDate(String iso) {
  final d = DateTime.parse(iso); // a broken date -> FormatException
  return '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]}';
}
