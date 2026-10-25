import '../models/court.dart';
import '../models/time_slot.dart';
import 'court_repository.dart';
import 'mock_store.dart';
import 'result.dart';

class MockCourtRepository implements CourtRepository {
  final MockStore _store;

  MockCourtRepository(this._store);

  @override
  Future<Result<List<Court>>> fetchAll() async {
    await Future.delayed(MockStore.latency);
    if (_store.simulateError) return const Err(MockStore.errNetwork);
    return Ok(List.of(_store.courts));
  }

  @override
  Future<Result<Court>> fetchById(String id) async {
    await Future.delayed(MockStore.latency);
    if (_store.simulateError) return const Err(MockStore.errNetwork);
    final court = _store.courts.where((c) => c.id == id).firstOrNull;
    if (court == null) return const Err('Площадка не существует');
    return Ok(court);
  }

  @override
  Future<Result<List<TimeSlot>>> fetchSlots(String courtId) async {
    await Future.delayed(MockStore.latency);
    if (_store.simulateError) return const Err(MockStore.errNetwork);
    final court = _store.courts.where((c) => c.id == courtId).firstOrNull;
    if (court == null) return const Err('Площадка не существует');
    return Ok(List.of(_store.slotsOf(courtId)));
  }
}