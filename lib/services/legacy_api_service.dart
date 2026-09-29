import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// The rest of the legacy Jaguza "CMD" API (§15 of Jaguza-API-Documentation.md)
/// — everything on `https://jaguzalivestockug.com/mobileapp/api/` beyond
/// login/register, which live in [LegacyAuthService].
///
/// **Verification status matters a lot more here than usual, so it's called
/// out per method.** Two endpoints have been hit against the live server
/// with real data returned (2026-09-29):
/// - [getDiseasesList] — confirmed. Returns real disease entries under a
///   `listing` key.
/// - [getDistricts] — confirmed. Returns Uganda's districts under `listing`.
/// - [decisionSupportOffline] — confirmed. A different, non-`cmd` endpoint;
///   returns a real bundle of decision-support content.
///
/// Every other method below is **written from the documented request shape
/// only and has never been called against the live server.** In particular:
/// - Every *write* command (`AddFarm`, `AddAnimal`, `AddMilk`,
///   `AddGestation`, `AddFarmExpense`, `addMarket`, `AddSicknessPost`,
///   `AddDoctorChat`, …) creates real rows on Jaguza's production database.
///   We already created one unintended account by treating a "just testing
///   with blank fields" registration call as harmless — it wasn't. Don't
///   call any write method here against production without a plan for what
///   happens to the data it creates.
/// - The success/response *shape* for nearly every read command is
///   inferred from the docs' `{param}` lists, not observed. Where the docs
///   say a field is "not inspected" (the client never parsed it), that's
///   reflected here as an unparsed passthrough map.
///
/// Treat this class as a typed request layer ready to verify, not as
/// confirmed-working code. Update the doc comment on a method once you've
/// captured a real response for it.
class LegacyApiService {
  LegacyApiService._();

  static const String baseUrl = String.fromEnvironment(
    'LEGACY_API_BASE_URL',
    defaultValue: 'https://jaguzalivestockug.com/mobileapp/api/',
  );

  static const Duration _timeout = Duration(seconds: 20);

  // ========== ACCOUNT ==========

  /// Confirmed live: returns `{"listing": [{"id","name","country_id"}, …]}`.
  static Future<List<dynamic>> getDistricts(String userId) async {
    final result = await _post('getDistricts', {'userId': userId});
    return _listing(result);
  }

  /// Unverified. Docs: §15 Account.
  static Future<Map<String, dynamic>> addFeedback({
    required String userId,
    required String acctype,
    required String description,
    required String telephone,
  }) async {
    return _post('addFeedback', {
      'user_id': userId,
      'acctype': acctype,
      'description': description,
      'telephone': telephone,
    });
  }

  /// Unverified. Docs say the response includes `notification_count`,
  /// `status`, `categories`, `category_status`.
  static Future<Map<String, dynamic>> notificationsCount(
    String userId, {
    String gcm = '',
    String acctype = '',
    String platform = 'android',
  }) async {
    return _post('notifications_count', {
      'user_id': userId,
      'gcm': gcm,
      'acctype': acctype,
      'platform': platform,
    });
  }

  /// Unverified.
  static Future<List<dynamic>> loadNotifications(String userId, int page) async {
    final result = await _post('load_notifications', {
      'user_id': userId,
      'page': '$page',
    });
    return _listing(result);
  }

  /// Registers an FCM/push token with the legacy backend. Unverified.
  static Future<Map<String, dynamic>> addDeviceGcm({
    required String gcmKey,
    required String userId,
    required String acctype,
  }) async {
    return _post('AddDeviceGCM', {
      'gcm_key': gcmKey,
      'user_id': userId,
      'acctype': acctype,
    });
  }

  // ========== FARM, ANIMALS, RECORDS ==========
  // Every method in this section is a WRITE or reads back data scoped to a
  // farm_id/user_id the caller supplies — none of it has been exercised
  // against the live server. See the class doc before calling these against
  // production.

  static Future<Map<String, dynamic>> addFarm({
    required String userId,
    required String farmName,
    required String actualLocation,
    required String district,
    required String longitude,
    required String latitude,
    String image = '',
  }) async {
    return _post('AddFarm', {
      'userId': userId,
      'farm_name': farmName,
      'actual_location': actualLocation,
      'district': district,
      'longitude': longitude,
      'latitude': latitude,
      'image': image,
    });
  }

  static Future<Map<String, dynamic>> getFarmDetails(
    String userId,
    String farmId,
  ) async {
    return _post('getFarmDetails', {'userId': userId, 'farm_id': farmId});
  }

  static Future<Map<String, dynamic>> setMainFarm(
    String userId,
    String farmId,
  ) async {
    return _post('SetMainFarm', {'userId': userId, 'farm_id': farmId});
  }

  static Future<Map<String, dynamic>> addAnimal({
    required String userId,
    required String farmId,
    required String name,
    required String categoryId,
    required String dob,
    required String tagId,
    required String gender,
    String motherAnimal = '',
    String breedVal = '',
    String weightVal = '',
    String image = '',
    String deviceId = '',
    String deviceIdTemp = '',
    String longitude = '',
    String latitude = '',
  }) async {
    return _post('AddAnimal', {
      'userId': userId,
      'farm_id': farmId,
      'name': name,
      'category_id': categoryId,
      'dob': dob,
      'tag_id': tagId,
      'mother_animal': motherAnimal,
      'gender': gender,
      'breedval': breedVal,
      'weightval': weightVal,
      'image': image,
      'deviceid': deviceId,
      'deviceid_temp': deviceIdTemp,
      'longitude': longitude,
      'latitude': latitude,
    });
  }

  static Future<Map<String, dynamic>> deleteAnimal({
    required String userId,
    required String acctype,
    required String animalId,
    required String farmId,
  }) async {
    return _post('deleteAnimal', {
      'userId': userId,
      'acctype': acctype,
      'animal_id': animalId,
      'farm_id': farmId,
    });
  }

  static Future<List<dynamic>> getAnimalList(
    String userId,
    String farmId, {
    String longitude = '',
    String latitude = '',
  }) async {
    final result = await _post('getAnimalList', {
      'userId': userId,
      'farm_id': farmId,
      'longitude': longitude,
      'latitude': latitude,
    });
    return _listing(result);
  }

  static Future<Map<String, dynamic>> getAnimalDetails(
    String userId,
    String farmId,
    String animalId,
  ) async {
    return _post('getAnimalDetails', {
      'userId': userId,
      'farm_id': farmId,
      'animal_id': animalId,
    });
  }

  static Future<List<dynamic>> getAnimalBreedsForCategory(
    String categoryId,
  ) async {
    final result = await _post('getAnimalBreedsForCategory', {
      'category_id': categoryId,
    });
    return _listing(result);
  }

  static Future<Map<String, dynamic>> addMilk({
    required String userId,
    required String farmId,
    required String animalId,
    required String amount,
    required String date,
    String remarks = '',
  }) async {
    return _post('AddMilk', {
      'userId': userId,
      'farm_id': farmId,
      'animal_id': animalId,
      'amount': amount,
      'remarks': remarks,
      'date': date,
    });
  }

  static Future<List<dynamic>> getMilkList(
    String userId,
    String farmId,
    String startDate,
    String endDate,
  ) async {
    final result = await _post('getMilkList', {
      'user_id': userId,
      'farm_id': farmId,
      'start_date': startDate,
      'end_date': endDate,
    });
    return _listing(result);
  }

  static Future<Map<String, dynamic>> addGestation({
    required String userId,
    required String farmId,
    required String animalId,
    required String method,
    required String inseminationDate,
    String birthDate = '',
    String notes = '',
    String doctorId = '',
  }) async {
    return _post('AddGestation', {
      'userId': userId,
      'farm_id': farmId,
      'animal_id': animalId,
      'method': method,
      'insemination_date': inseminationDate,
      'birth_date': birthDate,
      'notes': notes,
      'doctor_id': doctorId,
    });
  }

  static Future<List<dynamic>> getGestationList(
    String userId,
    String farmId,
  ) async {
    final result = await _post('getGestationList', {
      'userId': userId,
      'farm_id': farmId,
    });
    return _listing(result);
  }

  static Future<Map<String, dynamic>> addFarmExpense({
    required String userId,
    required String farmId,
    required String expense,
    required String amount,
    required String date,
    String description = '',
    String image = '',
  }) async {
    return _post('AddFarmExpense', {
      'userId': userId,
      'farm_id': farmId,
      'expense': expense,
      'amount': amount,
      'description': description,
      'date': date,
      'image': image,
    });
  }

  static Future<List<dynamic>> getExpensesList(
    String userId,
    String farmId,
    String startDate,
    String endDate,
  ) async {
    final result = await _post('getExpensesList', {
      'user_id': userId,
      'farm_id': farmId,
      'start_date': startDate,
      'end_date': endDate,
    });
    return _listing(result);
  }

  // ========== MARKETPLACE (legacy listings) ==========
  // Unverified — none of these have been called live.

  static Future<Map<String, dynamic>> addMarket({
    required String userId,
    required String farmId,
    required String title,
    required String location,
    required String price,
    required String content,
    required String postType,
    required String telephone,
    required String animalCategoryId,
    String image = '',
    String negotiable = '0',
    String longitude = '',
    String latitude = '',
  }) async {
    return _post('addMarket', {
      'userId': userId,
      'farm_id': farmId,
      'title': title,
      'location': location,
      'price': price,
      'content': content,
      'post_type': postType,
      'image': image,
      'telephone': telephone,
      'animal_category_id': animalCategoryId,
      'negotiable': negotiable,
      'longitude': longitude,
      'latitude': latitude,
    });
  }

  static Future<List<dynamic>> getMarketProducts({
    required String self,
    required String userId,
    String farmId = '',
    String longitude = '',
    String latitude = '',
    int page = 1,
  }) async {
    final result = await _post('getMarketProducts', {
      'self': self,
      'userId': userId,
      'farm_id': farmId,
      'longitude': longitude,
      'latitude': latitude,
      'page': '$page',
    });
    return _listing(result);
  }

  static Future<Map<String, dynamic>> getListingDetails({
    required String userId,
    required String itemId,
    String longitude = '',
    String latitude = '',
  }) async {
    return _post('getListingDetailsApp', {
      'userId': userId,
      'item_id': itemId,
      'longitude': longitude,
      'latitude': latitude,
    });
  }

  static Future<Map<String, dynamic>> addMarketComment(
    String userId,
    String postId,
    String content,
  ) async {
    return _post('AddMarketComment', {
      'userId': userId,
      'post_id': postId,
      'content': content,
    });
  }

  static Future<List<dynamic>> getMarketComments(
    String postId,
    int page,
  ) async {
    final result = await _post('getMarketComments', {
      'post_id': postId,
      'page': '$page',
    });
    return _listing(result);
  }

  static Future<Map<String, dynamic>> addOffer({
    required String userId,
    required String listingId,
    required String amount,
    required String phone,
  }) async {
    return _post('AddOffer', {
      'userId': userId,
      'listing_id': listingId,
      'amount': amount,
      'phone': phone,
    });
  }

  static Future<List<dynamic>> getProdOfferList(String postId, int page) async {
    final result = await _post('getProdOfferList', {
      'post_id': postId,
      'page': '$page',
    });
    return _listing(result);
  }

  static Future<Map<String, dynamic>> addReview({
    required String userId,
    required String listingId,
    required String content,
    required bool good,
  }) async {
    return _post('AddReview', {
      'userId': userId,
      'listing_id': listingId,
      'content': content,
      'good': good ? '1' : '0',
    });
  }

  // ========== HEALTH, COMMUNITY, SUPPORT ==========

  /// Confirmed live: returns `{"listing": [{"id","name","description"}, …]}`.
  static Future<List<dynamic>> getDiseasesList() async {
    final result = await _post('getDiseasesList', const {});
    return _listing(result);
  }

  /// Unverified.
  static Future<List<dynamic>> getAllSignsList() async {
    final result = await _post('getAllSignsList', const {});
    return _listing(result);
  }

  /// Unverified. `signsList` should be however the server expects multiple
  /// signs encoded (the docs don't say — likely comma-separated ids; confirm
  /// before relying on it).
  static Future<Map<String, dynamic>> diagnosis({
    required String userId,
    required String farmId,
    required String signsList,
    String longitude = '',
    String latitude = '',
  }) async {
    return _post('diagnosis', {
      'userId': userId,
      'farm_id': farmId,
      'signs_list': signsList,
      'longitude': longitude,
      'latitude': latitude,
    });
  }

  static Future<List<dynamic>> getDoctors(
    String userId, {
    String longitude = '',
    String latitude = '',
  }) async {
    final result = await _post('getDoctors', {
      'userId': userId,
      'longitude': longitude,
      'latitude': latitude,
    });
    return _listing(result);
  }

  static Future<List<dynamic>> getExtensionWorkers(
    String userId, {
    String longitude = '',
    String latitude = '',
  }) async {
    final result = await _post('getExtensionWorkers', {
      'userId': userId,
      'longitude': longitude,
      'latitude': latitude,
    });
    return _listing(result);
  }

  static Future<List<dynamic>> getFacilities(
    String userId, {
    String longitude = '',
    String latitude = '',
  }) async {
    final result = await _post('getFacilities', {
      'userId': userId,
      'longitude': longitude,
      'latitude': latitude,
    });
    return _listing(result);
  }

  static Future<List<dynamic>> getFarmingTips(
    String userId, {
    String longitude = '',
    String latitude = '',
  }) async {
    final result = await _post('getFarmingTips', {
      'userId': userId,
      'longitude': longitude,
      'latitude': latitude,
    });
    return _listing(result);
  }

  static Future<Map<String, dynamic>> addSicknessPost({
    required String userId,
    required String title,
    required String location,
    required String content,
    required String postType,
    required String telephone,
    String image = '',
    String longitude = '',
    String latitude = '',
  }) async {
    return _post('AddSicknessPost', {
      'userId': userId,
      'title': title,
      'location': location,
      'content': content,
      'post_type': postType,
      'image': image,
      'telephone': telephone,
      'longitude': longitude,
      'latitude': latitude,
    });
  }

  static Future<List<dynamic>> getSicknessPosts({
    required String self,
    required String userId,
    String longitude = '',
    String latitude = '',
    int page = 1,
  }) async {
    final result = await _post('getSicknessPosts', {
      'self': self,
      'userId': userId,
      'longitude': longitude,
      'latitude': latitude,
      'page': '$page',
    });
    return _listing(result);
  }

  static Future<Map<String, dynamic>> addPostComment(
    String userId,
    String postId,
    String content,
  ) async {
    return _post('AddPostComment', {
      'userId': userId,
      'post_id': postId,
      'content': content,
    });
  }

  static Future<List<dynamic>> getCommentsList(String postId, int page) async {
    final result = await _post('getCommentsList', {
      'post_id': postId,
      'page': '$page',
    });
    return _listing(result);
  }

  static Future<Map<String, dynamic>> addPostLike(
    String userId,
    String postId,
  ) async {
    return _post('AddnewPostLike', {'userId': userId, 'post_id': postId});
  }

  static Future<List<dynamic>> getMyQuestions(
    String userId,
    String acctype, {
    String longitude = '',
    String latitude = '',
  }) async {
    final result = await _post('getMyQuestions', {
      'userId': userId,
      'acctype': acctype,
      'longitude': longitude,
      'latitude': latitude,
    });
    return _listing(result);
  }

  static Future<Map<String, dynamic>> addDoctorChat({
    required String userId,
    required String postId,
    required String content,
    String image = '',
    String type = '',
    String reply = '',
    String replyId = '',
    String typeTo = '',
    String typeFrom = '',
  }) async {
    return _post('AddDoctorChat', {
      'userId': userId,
      'post_id': postId,
      'content': content,
      'image': image,
      'type': type,
      'reply': reply,
      'replyID': replyId,
      'type_to': typeTo,
      'type_from': typeFrom,
    });
  }

  static Future<List<dynamic>> getDoctorChatList({
    required String userId,
    required String postId,
    int page = 1,
    String type = '',
    String typeTo = '',
    String typeFrom = '',
  }) async {
    final result = await _post('getDoctorChatList', {
      'userId': userId,
      'post_id': postId,
      'page': '$page',
      'type': type,
      'type_to': typeTo,
      'type_from': typeFrom,
    });
    return _listing(result);
  }

  static Future<List<dynamic>> getDoctorLastContacted(
    String userId,
    int page, {
    String type = '',
    String longitude = '',
    String latitude = '',
  }) async {
    final result = await _post('getDoctorLastContacted', {
      'userId': userId,
      'page': '$page',
      'type': type,
      'longitude': longitude,
      'latitude': latitude,
    });
    return _listing(result);
  }

  // ========== DECISION SUPPORT ==========

  /// Confirmed live. A separate, non-`cmd` endpoint (§14). Each of
  /// `decision_support`, `decision_support_animal` and
  /// `decision_support_options` in the returned map is a JSON-encoded
  /// *string* of an array, per the docs — hence the decode step here.
  static Future<Map<String, List<dynamic>>> decisionSupportOffline() async {
    try {
      final response = await http
          .get(Uri.parse(
              '${baseUrl}update_2019_October/decision_support_offline.php'))
          .timeout(_timeout);
      final decoded = json.decode(response.body);
      if (decoded is! Map) return const {};
      final out = <String, List<dynamic>>{};
      for (final entry in decoded.entries) {
        final value = entry.value;
        if (value is List) {
          out['${entry.key}'] = value;
        } else if (value is String) {
          try {
            final inner = json.decode(value);
            if (inner is List) out['${entry.key}'] = inner;
          } catch (_) {
            // Leave unparsed entries out rather than guess their shape.
          }
        }
      }
      return out;
    } catch (e) {
      debugPrint('decisionSupportOffline error: $e');
      return const {};
    }
  }

  // ---- helpers ----

  static Future<Map<String, dynamic>> _post(
    String cmd,
    Map<String, String> fields,
  ) async {
    try {
      final response = await http
          .post(Uri.parse(baseUrl), body: {'cmd': cmd, ...fields})
          .timeout(_timeout);
      debugPrint('Legacy cmd=$cmd -> ${response.statusCode}');
      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'error': 'Unexpected response from the server'};
    } catch (e) {
      debugPrint('Legacy cmd=$cmd error: $e');
      return {'error': 'Cannot reach the server. Check your connection.'};
    }
  }

  /// Every list-shaped CMD response observed so far nests its array under
  /// `listing`; a bare array or a `data` key are supported too since the
  /// exact key isn't documented for most commands.
  static List<dynamic> _listing(Map<String, dynamic> result) {
    final listing = result['listing'] ?? result['data'] ?? result['list'];
    if (listing is List) return listing;
    return const [];
  }
}
