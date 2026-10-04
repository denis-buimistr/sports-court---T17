import 'court.dart';
import 'time_slot.dart';

enum BookingStatus {
  confirmed('Подтверждена'),
  completed('Завершена'),
  cancelled('Отменена');

  final String label;
  const BookingStatus(this.label);
}

class Booking {
  final String id;
  final Court court;
  final TimeSlot slot;
  final double totalPrice;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.court,
    required this.slot,
    required this.totalPrice,
    required this.status,
  });

  // upcoming = confirmed
  bool get isUpcoming => status == BookingStatus.confirmed;
}