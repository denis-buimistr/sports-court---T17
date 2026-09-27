import 'court.dart';

enum BookingStatus { confirmed, completed, cancelled }

class Booking {
  final String id;
  final Court court;
  final String date;
  final String startTime;
  final String endTime;
  final double totalPrice;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.court,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
  });
}