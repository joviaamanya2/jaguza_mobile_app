import 'dart:convert';
import 'package:http/http.dart' as http;
import 'php_api_service.dart';

/// Decision-support content (animal -> topics -> options) from the PHP
/// backend's October 2019 bundle. Screens keep their built-in content as a
/// fallback when this returns nothing.
class DecisionSupportService {
  DecisionSupportService._();

  static String get _endpoint =>
      '${PhpApiService.host}/api/update_2019_October/index.php';
  static String get _imageBase =>
      '${PhpApiService.host}/dashboard2.1/admin/pictures/decision_support/';

  static final Map<String, List<Map<String, dynamic>>> _cache = {};

  static Future<List<Map<String, dynamic>>> _list(Map<String, String> query) async {
    final res = await http
        .get(Uri.parse(_endpoint).replace(queryParameters: query))
        .timeout(const Duration(seconds: 20));
    final body = res.body;
    final start = body.indexOf('{');
    if (start < 0) return const [];
    final decoded = json.decode(body.substring(start));
    if (decoded is! Map || decoded['data'] is! List) return const [];
    return PhpApiService.listOf(decoded['data']);
  }

  static String? _image(dynamic file) {
    final f = '${file ?? ''}'.trim();
    return f.isEmpty ? null : '$_imageBase$f';
  }

  /// Topics for [animalName] ("Cattle", "Goats", ...). Each map has `title`,
  /// `description`, `image` (nullable URL) and `details` (list of strings).
  /// Returns an empty list on any failure.
  static Future<List<Map<String, dynamic>>> topicsFor(String animalName) async {
    final key = animalName.toLowerCase();
    final cached = _cache[key];
    if (cached != null) return cached;
    try {
      final animals = await _list({'cmd': 'getDecisionSupportAnimals'});
      final animal = animals.firstWhere(
        (a) {
          final n = '${a['name']}'.toLowerCase();
          return n == key || n.startsWith(key) || key.startsWith(n);
        },
        orElse: () => const {},
      );
      if (animal['id'] == null) return const [];

      final topics = await _list({
        'cmd': 'getDecisionSupportForOneAnimal',
        'animal': '${animal['id']}',
      });
      final result = await Future.wait(topics.map((t) async {
        var options = <Map<String, dynamic>>[];
        try {
          options = await _list({
            'cmd': 'getDecisionSupportOptionsForOneDecisionSupport',
            'decision_support': '${t['id']}',
          });
        } catch (_) {}
        return <String, dynamic>{
          'title': PhpApiService.cleanHtml('${t['title'] ?? ''}'),
          'description': PhpApiService.cleanHtml('${t['description'] ?? ''}'),
          'image': _image(t['image']),
          'details': options.map((o) {
            final title = PhpApiService.cleanHtml('${o['title'] ?? ''}');
            final body = PhpApiService.cleanHtml('${o['description'] ?? ''}');
            if (body.isEmpty) return title;
            return title.isEmpty ? body : '$title: $body';
          }).where((s) => s.isNotEmpty).toList(),
        };
      }));
      final usable = result.where((t) => '${t['title']}'.isNotEmpty).toList();
      if (usable.isNotEmpty) _cache[key] = usable;
      return usable;
    } catch (_) {
      return const [];
    }
  }
}
