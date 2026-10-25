import '../models/booking.dart';
import '../models/court.dart';
import '../models/time_slot.dart';
import 'mock_data.dart';

// in-memory source shared by both mock repositories:
// a new booking really occupies the slot
class MockStore {
  final List<Court> courts = List.of(MockData.courts);
  final List<Booking> bookings = MockData.seedBookings();
  final Map<String, List<TimeSlot>> _slots = {};

  // failure switch: demo scaffolding, dies on L5
  bool simulateError = false;

  static const latency = Duration(milliseconds: 800);
  static const errNetwork = 'Сервер не отвечает — повторите попытку';

  int _nextId = 100;
  String nextBookingId() => 'b${_nextId++}';

  MockStore() {
    // slots already taken by the seeded bookings
    for (final b in bookings.where((b) => b.status == BookingStatus.confirmed)) {
      setSlotAvailable(b.slot.courtId, b.slot.id, false);
    }
  }

  List<TimeSlot> slotsOf(String courtId) =>
      _slots.putIfAbsent(courtId, () => MockData.seedSlots(courtId));

  void setSlotAvailable(String courtId, String slotId, bool available) {
    final list = slotsOf(courtId);
    final i = list.indexWhere((s) => s.id == slotId);
    if (i == -1) return;
    list[i] = list[i].copyWith(isAvailable: available);
  }
}