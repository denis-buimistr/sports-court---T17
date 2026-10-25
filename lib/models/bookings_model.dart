import 'package:flutter/foundation.dart';
import '../data/booking_repository.dart';
import '../data/result.dart';
import 'booking.dart';
import 'court.dart';
import 'time_slot.dart';

class BookingsModel extends ChangeNotifier {
  BookingsModel(this._repository);

  final BookingRepository _repository;

  bool _loading = false;
  String? _error;
  List<Booking> _bookings = const [];

  bool get isLoading => _loading;
  String? get error => _error;
  List<Booking> get bookings => List.unmodifiable(_bookings);

  List<Booking> get upcoming =>
      List.unmodifiable(_bookings.where((b) => b.isUpcoming));
  List<Booking> get past =>
      List.unmodifiable(_bookings.where((b) => !b.isUpcoming));

  // the badge in the navigation bar reads this
  int get upcomingCount => _bookings.where((b) => b.isUpcoming).length;

  double get totalSpent => _bookings
      .where((b) => b.status != BookingStatus.cancelled)
      .fold(0, (sum, b) => sum + b.totalPrice);

  Booking? byId(String id) => _bookings.where((b) => b.id == id).firstOrNull;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();

    switch (await _repository.fetchAll()) {
      case Ok(:final value):
        _bookings = value;
      case Err(:final msg):
        _error = msg;
    }

    _loading = false;
    notifyListeners();
  }

  // null on success, a message on failure — same convention as validator
  Future<String?> book({required Court court, required TimeSlot slot}) async {
    final draft = Booking(
      id: '', // the storage gives the real identity (on L5: the server)
      court: court,
      slot: slot,
      totalPrice: court.pricePerHour,
      status: BookingStatus.confirmed,
    );

    switch (await _repository.create(draft)) {
      case Ok(:final value):
        _bookings = [..._bookings, value];
        notifyListeners(); // the list, the badge and the stats all find out
        return null;
      case Err(:final msg):
        return msg; // state untouched, the screen decides what to show
    }
  }

  Future<String?> cancel(String id) async {
    final booking = byId(id);
    if (booking == null) return 'Бронь не существует';

    final cancelled = booking.copyWith(status: BookingStatus.cancelled);
    switch (await _repository.update(cancelled)) {
      case Ok(:final value):
        _bookings = [
          for (final b in _bookings) if (b.id == value.id) value else b,
        ];
        notifyListeners();
        return null;
      case Err(:final msg):
        return msg;
    }
  }

  Future<String?> remove(String id) async {
    switch (await _repository.delete(id)) {
      case Ok():
        _bookings = _bookings.where((b) => b.id != id).toList();
        notifyListeners();
        return null;
      case Err(:final msg):
        return msg;
    }
  }
}