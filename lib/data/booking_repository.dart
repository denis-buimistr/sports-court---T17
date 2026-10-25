import '../models/booking.dart';
import 'result.dart';

abstract class BookingRepository {
  Future<Result<List<Booking>>> fetchAll();
  Future<Result<Booking>> fetchById(String id);
  Future<Result<Booking>> create(Booking draft);
  Future<Result<Booking>> update(Booking booking);
  Future<Result<void>> delete(String id);
}