import '../models/court.dart';
import '../models/time_slot.dart';
import 'result.dart';

abstract class CourtRepository {
  // L5 task 6: optional named parameters — the L4 call fetchAll() still compiles
  Future<Result<List<Court>>> fetchAll({int page = 1, int limit = 20, String? search});
  Future<Result<Court>> fetchById(String id);
  Future<Result<List<TimeSlot>>> fetchSlots(String courtId);
  // L5 task 7: a court photo — the file path comes from the device
  Future<Result<Court>> uploadPhoto(String courtId, String filePath);
}
