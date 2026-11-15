import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/court.dart';
import '../models/time_slot.dart';
import 'api_message.dart';
import 'court_repository.dart';
import 'http_repository_base.dart';
import 'json_mappers.dart';
import 'result.dart';

// second implementation of the L4 interface: same contract, real network
class HttpCourtRepository extends HttpRepositoryBase implements CourtRepository {
  HttpCourtRepository(super.baseUrl, super.tokens, {super.onUnauthorized});

  // GET /courts -> 200 {items, page, limit, total}
  @override
  Future<Result<List<Court>>> fetchAll() => guard(() async {
        final res = await http
            .get(Uri.parse('$baseUrl/courts'), headers: await headers())
            .timeout(HttpRepositoryBase.timeout); // layer 1 needs a timeout
        if (res.statusCode == 401) return Err(await sessionDied());
        if (res.statusCode != 200) return Err(apiMessage(res)); // layer 2

        final data = jsonDecode(res.body) as Map<String, dynamic>; // envelope!
        return Ok((data['items'] as List)
            .map((e) => courtFromJson(e as Map<String, dynamic>))
            .toList()); // layer 3 throws here if the body is not ours
      });

  // GET /courts/{id} -> 200 court | 404
  @override
  Future<Result<Court>> fetchById(String id) => guard(() async {
        final res = await http
            .get(Uri.parse('$baseUrl/courts/$id'), headers: await headers())
            .timeout(HttpRepositoryBase.timeout);
        if (res.statusCode == 401) return Err(await sessionDied());
        if (res.statusCode != 200) return Err(apiMessage(res)); // 404 -> "Запись не существует"

        return Ok(courtFromJson(jsonDecode(res.body) as Map<String, dynamic>));
      });

  // GET /courts/{id}/slots -> 200 [slot] (today's slots; a plain list)
  @override
  Future<Result<List<TimeSlot>>> fetchSlots(String courtId) => guard(() async {
        final res = await http
            .get(Uri.parse('$baseUrl/courts/$courtId/slots'), headers: await headers())
            .timeout(HttpRepositoryBase.timeout);
        if (res.statusCode == 401) return Err(await sessionDied());
        if (res.statusCode != 200) return Err(apiMessage(res));

        return Ok((jsonDecode(res.body) as List)
            .map((e) => timeSlotFromJson(e as Map<String, dynamic>))
            .toList());
      });
}
