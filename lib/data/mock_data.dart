import '../models/booking.dart';
import '../models/court.dart';
import '../models/time_slot.dart';

class MockData {
  const MockData._();

  // slot shown on the confirm screen
  static const String demoDate = 'Ср, 7 окт';
  static const String demoStart = '19:00';
  static const String demoEnd = '20:00';

  static const List<String> districts = [
    'Центр',
    'Ботаника',
    'Буюканы',
    'Рышкановка',
    'Чеканы',
    'Телецентр',
  ];

  static const List<Court> courts = [
    Court(
      id: '1',
      name: 'Arena Dacia',
      sport: Sport.football,
      district: 'Ботаника',
      address: 'бул. Дачия, 45',
      pricePerHour: 400,
      imageUrl: 'https://example.com/courts/arena-dacia.jpg',
      amenities: ['Искусственный газон', 'Освещение', 'Раздевалки', 'Душ'],
    ),
    Court(
      id: '2',
      name: 'Green Field Buiucani',
      sport: Sport.football,
      district: 'Буюканы',
      address: 'ул. Албишоара, 78',
      pricePerHour: 350,
      imageUrl: 'https://example.com/courts/green-field.jpg',
      amenities: ['Искусственный газон', 'Освещение', 'Трибуны'],
    ),
    Court(
      id: '3',
      name: 'Tennis Club Centru',
      sport: Sport.tennis,
      district: 'Центр',
      address: 'ул. Букурешть, 12',
      pricePerHour: 180,
      imageUrl: 'https://example.com/courts/tennis-centru.jpg',
      amenities: ['Грунтовые корты', 'Аренда ракеток', 'Тренер по запросу'],
    ),
    Court(
      id: '4',
      name: 'Ace Tennis Academy',
      sport: Sport.tennis,
      district: 'Рышкановка',
      address: 'ул. Каля Орхеюлуй, 33',
      pricePerHour: 200,
      imageUrl: 'https://example.com/courts/ace-tennis.jpg',
      amenities: ['Крытый корт', 'Душ', 'Парковка'],
    ),
    Court(
      id: '5',
      name: 'Basket Zone',
      sport: Sport.basketball,
      district: 'Чеканы',
      address: 'бул. Мирча чел Бэтрын, 21',
      pricePerHour: 220,
      imageUrl: 'https://example.com/courts/basket-zone.jpg',
      amenities: ['Крытый зал', 'Кондиционер', 'Раздевалки'],
    ),
    Court(
      id: '6',
      name: 'Dunk City',
      sport: Sport.basketball,
      district: 'Центр',
      address: 'ул. Измаил, 54',
      pricePerHour: 260,
      imageUrl: 'https://example.com/courts/dunk-city.jpg',
      amenities: ['Паркет', 'Табло', 'Парковка'],
    ),
    Court(
      id: '7',
      name: 'Sand & Net Volleyball',
      sport: Sport.volleyball,
      district: 'Телецентр',
      address: 'ул. Дечебал, 80',
      pricePerHour: 150,
      imageUrl: 'https://example.com/courts/sand-net.jpg',
      amenities: ['Песчаное покрытие', 'Душ', 'Аренда мяча'],
    ),
    Court(
      id: '8',
      name: 'Arena Telecentru',
      sport: Sport.football,
      district: 'Телецентр',
      address: 'бул. Траян, 9',
      pricePerHour: 320,
      imageUrl: 'https://example.com/courts/arena-telecentru.jpg',
      amenities: ['Искусственный газон', 'Освещение', 'Трибуны', 'Раздевалки'],
    ),
  ];

  // 14 hourly slots, 08:00-22:00
  static List<TimeSlot> slotsFor(String courtId) {
    const hours = [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21];
    final busy = (int.tryParse(courtId) ?? 1).isEven
        ? const {9, 11, 12, 16, 17}
        : const {10, 12, 13, 17, 18};

    return [
      for (final h in hours)
        TimeSlot(
          id: '$courtId-$h',
          courtId: courtId,
          date: demoDate,
          startTime: _hour(h),
          endTime: _hour(h + 1),
          isAvailable: !busy.contains(h),
        ),
    ];
  }

  static String _hour(int h) => '${h.toString().padLeft(2, '0')}:00';

  // 3 upcoming + 5 past
  static final List<Booking> bookings = [
    Booking(
      id: 'b1',
      court: courts[0],
      slot: const TimeSlot(id: 's1', courtId: '1', date: 'Ср, 7 окт', startTime: '19:00', endTime: '20:00', isAvailable: false),
      totalPrice: 400,
      status: BookingStatus.confirmed,
    ),
    Booking(
      id: 'b2',
      court: courts[2],
      slot: const TimeSlot(id: 's2', courtId: '3', date: 'Пт, 9 окт', startTime: '18:00', endTime: '19:00', isAvailable: false),
      totalPrice: 180,
      status: BookingStatus.confirmed,
    ),
    Booking(
      id: 'b3',
      court: courts[4],
      slot: const TimeSlot(id: 's3', courtId: '5', date: 'Вс, 11 окт', startTime: '11:00', endTime: '12:00', isAvailable: false),
      totalPrice: 220,
      status: BookingStatus.confirmed,
    ),
    Booking(
      id: 'b4',
      court: courts[1],
      slot: const TimeSlot(id: 's4', courtId: '2', date: 'Ср, 30 сен', startTime: '20:00', endTime: '21:00', isAvailable: false),
      totalPrice: 350,
      status: BookingStatus.completed,
    ),
    Booking(
      id: 'b5',
      court: courts[5],
      slot: const TimeSlot(id: 's5', courtId: '6', date: 'Пн, 28 сен', startTime: '19:00', endTime: '20:00', isAvailable: false),
      totalPrice: 260,
      status: BookingStatus.completed,
    ),
    Booking(
      id: 'b6',
      court: courts[2],
      slot: const TimeSlot(id: 's6', courtId: '3', date: 'Сб, 26 сен', startTime: '10:00', endTime: '11:00', isAvailable: true),
      totalPrice: 180,
      status: BookingStatus.cancelled,
    ),
    Booking(
      id: 'b7',
      court: courts[0],
      slot: const TimeSlot(id: 's7', courtId: '1', date: 'Ср, 23 сен', startTime: '19:00', endTime: '20:00', isAvailable: false),
      totalPrice: 400,
      status: BookingStatus.completed,
    ),
    Booking(
      id: 'b8',
      court: courts[6],
      slot: const TimeSlot(id: 's8', courtId: '7', date: 'Вс, 20 сен', startTime: '16:00', endTime: '17:00', isAvailable: true),
      totalPrice: 150,
      status: BookingStatus.cancelled,
    ),
  ];
}