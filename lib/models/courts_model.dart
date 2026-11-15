import 'package:flutter/foundation.dart';

import '../data/court_repository.dart';
import '../data/result.dart';
import 'court.dart';

class CourtsModel extends ChangeNotifier {
  CourtsModel(
    this._repository,
  ); // DI: the storage comes in through the constructor

  final CourtRepository _repository; // interface type, not the mock

  static const _limit = 20; // one page = one slice from the server

  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = false;
  int _page = 1;
  String? _search;
  String? _error;
  List<Court> _courts = const [];

  bool get isLoading => _loading;
  bool get hasMore => _hasMore; // the list tail shows a spinner while true
  String? get search => _search;
  String? get error => _error;
  List<Court> get courts => List.unmodifiable(_courts);

  // derived from the loaded data: the screen no longer knows the seed
  List<String> get districts {
    final set = {for (final c in _courts) c.district};
    return List.unmodifiable(set.toList()..sort());
  }

  Court? byId(String id) => _courts.where((c) => c.id == id).firstOrNull;

  // load() stays valid as on L4; retry keeps the current filter
  Future<void> load({String? search}) async {
    _search = search ?? _search;
    _page = 1;
    _loading = true;
    _error = null;
    notifyListeners(); // subscribed screens enter the loading state

    switch (await _repository.fetchAll(
      page: 1,
      limit: _limit,
      search: _search,
    )) {
      case Ok(:final value):
        _courts = value;
        _hasMore = value.length == _limit; // a full page -> probably more
      case Err(:final msg):
        _error = msg;
    }

    _loading = false;
    notifyListeners(); // and leave it: with data or with an error, never silently
  }

  // Called from itemBuilder, i.e. in the middle of build: a synchronous
  // notifyListeners() here would throw "markNeedsBuild() called during build",
  // so _loadingMore is set WITHOUT notifying (the tail spinner is already on
  // screen through hasMore). Without the guard pages would be duplicated.
  Future<void> loadMore() async {
    if (_loadingMore || _loading || !_hasMore) return;
    _loadingMore = true;

    switch (await _repository.fetchAll(
      page: _page + 1,
      limit: _limit,
      search: _search,
    )) {
      case Ok(:final value):
        _page += 1;
        _courts = [..._courts, ...value]; // the page is glued on
        _hasMore = value.length == _limit;
      case Err():
        _hasMore = false; // stop the tail; pull-to-refresh / retry reloads
    }

    _loadingMore = false;
    notifyListeners();
  }

  // null on success, a message on failure — the L4 convention
  Future<String?> uploadPhoto(String courtId, String filePath) async {
    switch (await _repository.uploadPhoto(courtId, filePath)) {
      case Ok(:final value):
        _courts = [for (final c in _courts) if (c.id == value.id) value else c];
        notifyListeners(); // the list card and the details photo update
        return null;
      case Err(:final msg):
        return msg;
    }
  }
}
