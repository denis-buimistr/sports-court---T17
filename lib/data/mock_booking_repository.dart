import '../models/booking.dart';
import 'booking_repository.dart';
import 'mock_store.dart';
import 'result.dart';

class MockBookingRepository implements BookingRepository {
  final MockStore _store;

  MockBookingRepository(this._store);

  @override
  Future<Result<List<Booking>>> fetchAll() async {
    await Future.delayed(MockStore.latency);
    if (_store.simulateError) return const Err(MockStore.errNetwork);
    return Ok(List.of(_store.bookings));
  }

  @override
  Future<Result<Booking>> fetchById(String id) async {
    await Future.delayed(MockStore.latency);
    if (_store.simulateError) return const Err(MockStore.errNetwork);
    final booking = _store.bookings.where((b) => b.id == id).firstOrNull;
    if (booking == null) return const Err('Бронь не существует');
    return Ok(booking);
  }

  @override
  Future<Result<Booking>> create(Booking draft) async {
    await Future.delayed(MockStore.latency);
    if (_store.simulateError) return const Err(MockStore.errNetwork);

    final taken = _store.bookings.any(
      (b) => b.slot.id == draft.slot.id && b.status == BookingStatus.confirmed,
    );
    if (taken) return const Err('Этот слот уже занят');

    // the id comes from the storage, not from the screen
    final created = draft.copyWith(id: _store.nextBookingId());
    _store.bookings.add(created);
    _store.setSlotAvailable(created.slot.courtId, created.slot.id, false);
    return Ok(created);
  }

  @override
  Future<Result<Booking>> update(Booking booking) async {
    await Future.delayed(MockStore.latency);
    if (_store.simulateError) return const Err(MockStore.errNetwork);

    final i = _store.bookings.indexWhere((b) => b.id == booking.id);
    if (i == -1) return const Err('Бронь не существует');

    _store.bookings[i] = booking;
    // a cancelled booking frees its slot
    if (booking.status == BookingStatus.cancelled) {
      _store.setSlotAvailable(booking.slot.courtId, booking.slot.id, true);
    }
    return Ok(booking);
  }

  @override
  Future<Result<void>> delete(String id) async {
    await Future.delayed(MockStore.latency);
    if (_store.simulateError) return const Err(MockStore.errNetwork);

    final booking = _store.bookings.where((b) => b.id == id).firstOrNull;
    if (booking == null) return const Err('Бронь не существует');

    _store.bookings.removeWhere((b) => b.id == id);
    _store.setSlotAvailable(booking.slot.courtId, booking.slot.id, true);
    return const Ok(null);
  }
}