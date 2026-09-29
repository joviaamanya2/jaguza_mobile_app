import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jaguza_app/services/legacy_api_service.dart';

// Run with:
//   flutter test test/legacy_api_service_test.dart \
//     --dart-define=LEGACY_API_BASE_URL=http://127.0.0.1:8765/
//
// Only covers the methods with a confirmed live response shape
// (getDiseasesList, getDistricts, decisionSupportOffline) plus the generic
// `_listing`/error-handling paths shared by every other method in the
// class. The unverified write/read methods aren't covered here because
// there is nothing confirmed to assert against yet — see the class doc.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late HttpServer server;

  setUpAll(() async {
    HttpOverrides.global = null; // allow real loopback sockets
    server = await HttpServer.bind('127.0.0.1', 8765);
    server.listen((req) async {
      if (req.uri.path.endsWith('decision_support_offline.php')) {
        req.response.headers.contentType = ContentType.json;
        req.response.write(jsonEncode({
          // Confirmed shape: each value is a JSON-encoded *string* of an array.
          'decision_support_animal': jsonEncode([
            {'id': '37', 'name': 'Cattle', 'image': '1.jpg'},
          ]),
          'decision_support': jsonEncode([
            {'id': '1', 'title': 'Feeding'},
          ]),
          'decision_support_options': jsonEncode([]),
        }));
        await req.response.close();
        return;
      }

      final body = Uri.splitQueryString(await utf8.decoder.bind(req).join());
      Object reply;
      switch (body['cmd']) {
        case 'getDiseasesList':
          reply = {
            'listing': [
              {'id': 1, 'name': ' Foot-and-Mouth', 'description': 'A severe viral disease.'},
            ],
          };
          break;
        case 'getDistricts':
          reply = {
            'listing': [
              {'id': 1, 'name': 'Abim', 'country_id': 1},
            ],
          };
          break;
        case 'getAllSignsList':
          reply = 'not json'; // exercise the malformed-response path
          break;
        default:
          reply = {'status': 'wrong', 'message': 'Unknown cmd in test'};
      }
      req.response.headers.contentType = ContentType.json;
      req.response.write(reply is String ? reply : jsonEncode(reply));
      await req.response.close();
    });
  });

  tearDownAll(() => server.close(force: true));

  test('base url points at the test server', () {
    expect(LegacyApiService.baseUrl, 'http://127.0.0.1:8765/');
  });

  test('getDiseasesList returns the listing array', () async {
    final result = await LegacyApiService.getDiseasesList();
    expect(result, hasLength(1));
    expect(result.first['name'], ' Foot-and-Mouth');
  });

  test('getDistricts returns the listing array', () async {
    final result = await LegacyApiService.getDistricts('1');
    expect(result, hasLength(1));
    expect(result.first['name'], 'Abim');
  });

  test('an unrecognised cmd/status yields an empty listing, not a crash', () async {
    final result = await LegacyApiService.getAllSignsList();
    expect(result, isEmpty);
  });

  test('decisionSupportOffline decodes the nested JSON-string arrays', () async {
    final bundle = await LegacyApiService.decisionSupportOffline();
    expect(bundle['decision_support_animal'], hasLength(1));
    expect(bundle['decision_support_animal']!.first['name'], 'Cattle');
    expect(bundle['decision_support'], hasLength(1));
    expect(bundle['decision_support_options'], isEmpty);
  });
}
