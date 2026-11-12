import '../models/court.dart';
import '../models/time_slot.dart';
import 'result.dart';

abstract class CourtRepository {
  Future<Result<List<Court>>> fetchAll();
  Future<Result<Court>> fetchById(String id);
  Future<Result<List<TimeSlot>>> fetchSlots(String courtId);
}
