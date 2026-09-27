
class TimeSlot {
  final String id;
  final String courtId;
  final String date;
  final String startTime;
  final String endTime;
  final bool isAvailable;

  const TimeSlot({
    required this.id,
    required this.courtId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });
}