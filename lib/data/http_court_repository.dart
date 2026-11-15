import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/court.dart';
import '../models/time_slot.dart';
import 'api_message.dart';
import 'court_repository.dart';
import 'file_api.dart';
import 'http_repository_base.dart';
import 'json_mappers.dart';
import 'result.dart';

// second implementation of the L4 interface: same contract, real network
class HttpCourtRepository extends HttpRepositoryBase
    implements CourtRepository {
  HttpCourtRepository(super.baseUrl, super.tokens, {super.onUnauthorized})
      : _files = FileApi(baseUrl, tokens);

  final FileApi _files;

  // GET /courts?page=&limit=&search= -> 200 {items, page, limit, total}
  // the search happens ON THE SERVER: the phone receives only its slice
  @override
  Future<Result<List<Court>>> fetchAll({
    int page = 1,
    int limit = 20,
    String? search,
  }) => guard(() async {
    final uri = Uri.parse('$baseUrl/courts').replace(
      queryParameters: {
        'page': '$page',
        'limit': '$limit',
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    final res = await http
        .get(uri, headers: await headers())
        .timeout(HttpRepositoryBase.timeout); // layer 1 needs a timeout
    if (res.statusCode == 401) return Err(await sessionDied());
    if (res.statusCode != 200) return Err(apiMessage(res)); // layer 2

    final data = jsonDecode(res.body) as Map<String, dynamic>; // envelope!
    return Ok(
      (data['items'] as List)
          .map((e) => courtFromJson(e as Map<String, dynamic>, baseUrl: baseUrl))
          .toList(),
    ); // layer 3 throws here if the body is not ours
  });

  // GET /courts/{id} -> 200 court | 404
  @override
  Future<Result<Court>> fetchById(String id) => guard(() async {
    final res = await http
        .get(Uri.parse('$baseUrl/courts/$id'), headers: await headers())
        .timeout(HttpRepositoryBase.timeout);
    if (res.statusCode == 401) return Err(await sessionDied());
    // 404 -> "Запись не существует"
    if (res.statusCode != 200) return Err(apiMessage(res));

    return Ok(courtFromJson(jsonDecode(res.body) as Map<String, dynamic>, baseUrl: baseUrl));
  });

  // GET /courts/{id}/slots -> 200 [slot] (today's slots; a plain list)
  @override
  Future<Result<List<TimeSlot>>> fetchSlots(String courtId) => guard(() async {
    final res = await http
        .get(
          Uri.parse('$baseUrl/courts/$courtId/slots'),
          headers: await headers(),
        )
        .timeout(HttpRepositoryBase.timeout);
    if (res.statusCode == 401) return Err(await sessionDied());
    if (res.statusCode != 200) return Err(apiMessage(res));

    return Ok(
      (jsonDecode(res.body) as List)
          .map((e) => timeSlotFromJson(e as Map<String, dynamic>))
          .toList(),
    );
  });

  // L5 task 7: the photo goes to POST /files (multipart), then its
  // relative url is stored on the court: PUT /courts/{id}/image
  @override
  Future<Result<Court>> uploadPhoto(String courtId, String filePath) async {
    switch (await _files.upload(filePath)) {
      case Err(:final msg):
        return Err(msg);
      case Ok(value: final url):
        return guard(() async {
          final res = await http
              .put(
                Uri.parse('$baseUrl/courts/$courtId/image'),
                headers: await headers(),
                body: jsonEncode({'imageUrl': url}),
              )
              .timeout(HttpRepositoryBase.timeout);
          if (res.statusCode == 401) return Err(await sessionDied());
          if (res.statusCode != 200) return Err(apiMessage(res));
          return Ok(
            courtFromJson(jsonDecode(res.body) as Map<String, dynamic>, baseUrl: baseUrl),
          );
        });
    }
  }
}
