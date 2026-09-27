
import '../models/court.dart';
import '../models/time_slot.dart';
import '../models/booking.dart';

class MockData {
  static const List<Court> courts = [
    Court(
      id: '1',
      name: 'Arena Football Club',
      sport: 'Футбол',
      address: 'ул. Штефан чел Маре, 12',
      pricePerHour: 300,
      imageUrl: 'https://picsum.photos/seed/football1/400/250',
      amenities: ['Раздевалка', 'Душ', 'Освещение'],
    ),
    Court(
      id: '2',
      name: 'Tennis Club Chișinău',
      sport: 'Теннис',
      address: 'бул. Дачия, 45',
      pricePerHour: 150,
      imageUrl: 'https://picsum.photos/seed/tennis1/400/250',
      amenities: ['Крытый корт', 'Аренда ракеток'],
    ),
    Court(
      id: '3',
      name: 'Basket Zone',
      sport: 'Баскетбол',
      address: 'ул. Албишоара, 78',
      pricePerHour: 200,
      imageUrl: 'https://picsum.photos/seed/basket1/400/250',
      amenities: ['Крытая площадка', 'Парковка'],
    ),
    Court(
      id: '4',
      name: 'Green Field Arena',
      sport: 'Футбол',
      address: 'ул. Albișoara, 101',
      pricePerHour: 350,
      imageUrl: 'https://picsum.photos/seed/football2/400/250',
      amenities: ['Искусственный газон', 'Освещение', 'Трибуны'],
    ),
    Court(
      id: '5',
      name: 'Smash Tennis Academy',
      sport: 'Теннис',
      address: 'ул. Ismail, 33',
      pricePerHour: 180,
      imageUrl: 'https://picsum.photos/seed/tennis2/400/250',
      amenities: ['Открытый корт', 'Тренер по запросу'],
    ),
    Court(
      id: '6',
      name: 'Dunk City',
      sport: 'Баскетбол',
      address: 'бул. Renașterii, 22',
      pricePerHour: 220,
      imageUrl: 'https://picsum.photos/seed/basket2/400/250',
      amenities: ['Кондиционер', 'Раздевалка'],
    ),
  ];

  static List<TimeSlot> timeSlotsForCourt(String courtId) => [
        TimeSlot(id: '1', courtId: courtId, date: '28 сентября', startTime: '08:00', endTime: '09:00', isAvailable: true),
        TimeSlot(id: '2', courtId: courtId, date: '28 сентября', startTime: '09:00', endTime: '10:00', isAvailable: false),
        TimeSlot(id: '3', courtId: courtId, date: '28 сентября', startTime: '10:00', endTime: '11:00', isAvailable: true),
        TimeSlot(id: '4', courtId: courtId, date: '28 сентября', startTime: '11:00', endTime: '12:00', isAvailable: true),
        TimeSlot(id: '5', courtId: courtId, date: '28 сентября', startTime: '18:00', endTime: '19:00', isAvailable: false),
        TimeSlot(id: '6', courtId: courtId, date: '28 сентября', startTime: '19:00', endTime: '20:00', isAvailable: true),
      ];

  static List<Booking> get bookings => [
        Booking(
          id: '1',
          court: courts[0],
          date: '30 сентября',
          startTime: '18:00',
          endTime: '19:00',
          totalPrice: 300,
          status: BookingStatus.confirmed,
        ),
        Booking(
          id: '2',
          court: courts[2],
          date: '20 сентября',
          startTime: '10:00',
          endTime: '11:00',
          totalPrice: 200,
          status: BookingStatus.completed,
        ),
        Booking(
          id: '3',
          court: courts[1],
          date: '15 сентября',
          startTime: '09:00',
          endTime: '10:00',
          totalPrice: 150,
          status: BookingStatus.cancelled,
        ),
      ];
}