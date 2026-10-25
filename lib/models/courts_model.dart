import 'package:flutter/foundation.dart';
import '../data/court_repository.dart';
import '../data/result.dart';
import 'court.dart';

class CourtsModel extends ChangeNotifier {
  CourtsModel(this._repository); // DI: the storage comes in through the constructor

  final CourtRepository _repository; // interface type, not the mock

  bool _loading = false;
  String? _error;
  List<Court> _courts = const [];

  bool get isLoading => _loading;
  String? get error => _error;
  List<Court> get courts => List.unmodifiable(_courts);

  // derived from the loaded data: the screen no longer knows the seed
  List<String> get districts {
    final set = {for (final c in _courts) c.district};
    return List.unmodifiable(set.toList()..sort());
  }

  Court? byId(String id) => _courts.where((c) => c.id == id).firstOrNull;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners(); // subscribed screens enter the loading state

    switch (await _repository.fetchAll()) {
      case Ok(:final value):
        _courts = value;
      case Err(:final msg):
        _error = msg;
    }

    _loading = false;
    notifyListeners(); // and leave it: with data or with an error, never silently
  }
}