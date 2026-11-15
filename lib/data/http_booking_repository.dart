import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/booking.dart';
import 'api_message.dart';
import 'booking_repository.dart';
import 'http_repository_base.dart';
import 'json_mappers.dart';
import 'result.dart';

// second implementation of the L4 interface: each method maps 1:1
// onto the REST route from the L4 contract table
class HttpBookingRepository extends HttpRepositoryBase implements BookingRepository {
  HttpBookingRepository(super.baseUrl, super.tokens, {super.onUnauthorized});

  Booking _decode(String body) =>
      bookingFromJson(jsonDecode(body) as Map<String, dynamic>, baseUrl: baseUrl);

  // GET /bookings -> 200 {items, page, limit, total}
  @override
  Future<Result<List<Booking>>> fetchAll() => guard(() async {
        final res = await http
            .get(Uri.parse('$baseUrl/bookings'), headers: await headers())
            .timeout(HttpRepositoryBase.timeout);
        if (res.statusCode == 401) return Err(await sessionDied());
        if (res.statusCode != 200) return Err(apiMessage(res));

        final data = jsonDecode(res.body) as Map<String, dynamic>;
        return Ok((data['items'] as List)
            .map((e) => bookingFromJson(e as Map<String, dynamic>, baseUrl: baseUrl))
            .toList());
      });

  // GET /bookings/{id} -> 200 | 404 (someone else's booking looks the same)
  @override
  Future<Result<Booking>> fetchById(String id) => guard(() async {
        final res = await http
            .get(Uri.parse('$baseUrl/bookings/$id'), headers: await headers())
            .timeout(HttpRepositoryBase.timeout);
        if (res.statusCode == 401) return Err(await sessionDied());
        if (res.statusCode != 200) return Err(apiMessage(res));
        return Ok(_decode(res.body));
      });

  // POST /bookings -> 201, the id comes from the server; 409 = slot taken
  @override
  Future<Result<Booking>> create(Booking draft) => guard(() async {
        final res = await http
            .post(Uri.parse('$baseUrl/bookings'),
                headers: await headers(), body: jsonEncode(draft.toJson()))
            .timeout(HttpRepositoryBase.timeout);
        if (res.statusCode == 401) return Err(await sessionDied());
        if (res.statusCode != 201) return Err(apiMessage(res)); // 400 / 409
        return Ok(_decode(res.body));
      });

  // PUT /bookings/{id} -> 200, replaces by id (here: the status)
  @override
  Future<Result<Booking>> update(Booking booking) => guard(() async {
        final res = await http
            .put(Uri.parse('$baseUrl/bookings/${booking.id}'),
                headers: await headers(), body: jsonEncode(booking.toJson()))
            .timeout(HttpRepositoryBase.timeout);
        if (res.statusCode == 401) return Err(await sessionDied());
        if (res.statusCode != 200) return Err(apiMessage(res));
        return Ok(_decode(res.body));
      });

  // DELETE /bookings/{id} -> 204: the body is EMPTY — no jsonDecode on it (C8 trap)
  @override
  Future<Result<void>> delete(String id) => guard(() async {
        final res = await http
            .delete(Uri.parse('$baseUrl/bookings/$id'), headers: await headers())
            .timeout(HttpRepositoryBase.timeout);
        if (res.statusCode == 401) return Err(await sessionDied());
        if (res.statusCode != 204) return Err(apiMessage(res));
        return const Ok(null);
      });
}
