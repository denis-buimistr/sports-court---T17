import 'package:flutter/foundation.dart';
import '../data/court_repository.dart';
import '../data/result.dart';
import 'time_slot.dart';

class SlotsModel extends ChangeNotifier {
  SlotsModel(this._repository);

  final CourtRepository _repository;

  String? _courtId;
  bool _loading = false;
  String? _error;
  List<TimeSlot> _slots = const [];

  bool get isLoading => _loading;
  String? get error => _error;
  String? get courtId => _courtId;
  List<TimeSlot> get slots => List.unmodifiable(_slots);

  int get freeCount => _slots.where((s) => s.isAvailable).length;

  TimeSlot? byId(String id) => _slots.where((s) => s.id == id).firstOrNull;

  Future<void> load(String courtId) async {
    _courtId = courtId;
    _loading = true;
    _error = null;
    _slots = const [];
    notifyListeners();

    switch (await _repository.fetchSlots(courtId)) {
      case Ok(:final value):
        _slots = value;
      case Err(:final msg):
        _error = msg;
    }

    _loading = false;
    notifyListeners();
  }
}