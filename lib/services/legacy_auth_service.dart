import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Auth against the legacy Jaguza "CMD" PHP backend
/// (`https://jaguzalivestockug.com/mobileapp/api/`, §15 of
/// Jaguza-API-Documentation.md).
///
/// One endpoint, many operations selected by a `cmd` form field. Like the V2
/// backend this replaces, there are no tokens — identity is a plain
/// `user_id`, so a successful login/register just stores whatever the server
/// returned as the local session.
///
/// **Response shapes below are only confirmed for the failure cases** (they
/// were captured live from the real server on 2026-09-29). The *success*
/// shape for `cmd=login` was never observed — probing it further with guessed
/// credentials would mean more speculative writes against Jaguza's
/// production user database, which we've already done once by accident (see
/// the `addUsers` note below) and shouldn't repeat. Parsing here is
/// deliberately tolerant: anything that isn't the known `status: "wrong"`
/// failure, and that carries a `user_id`, is treated as success. **Verify
/// this against a real successful login (a network capture from the live
/// Android app, or a real test account) before shipping.**
///
/// Confirmed live on 2026-09-29:
/// - `cmd=login` with bad credentials → `{"status":"wrong","message":"Login
///   failed, wrong user name or password"}`.
/// - `cmd=addUsers` accepted blank/invalid fields and created a real account
///   (`{"status":"ok","user_id":"...", "name","email","phone","role",
///   "acctype","message"}`) — the server does **not** validate input, so the
///   client must (email format, non-empty phone, etc.) before calling it.
///   Registration with a real phone number sends an SMS verification code
///   per `addUsers`'s message; this class does not yet implement the
///   `logincode`/`resendcode` verification step, so freshly-registered
///   accounts may be unable to log in until that's added.
/// - `cmd=forgotPassword` on an unknown email → `{"status":"wrong"}`.
class LegacyAuthService {
  LegacyAuthService._();

  /// Set `--dart-define=USE_LEGACY_AUTH=false` to fall back to the Laravel
  /// `ApiService` login/register.
  static const bool enabled = bool.fromEnvironment(
    'USE_LEGACY_AUTH',
    defaultValue: true,
  );

  static const String baseUrl = String.fromEnvironment(
    'LEGACY_API_BASE_URL',
    defaultValue: 'https://jaguzalivestockug.com/mobileapp/api/',
  );

  static const String _sessionKey = 'legacy_user';
  static const Duration _timeout = Duration(seconds: 20);

  static Map<String, dynamic>? _user;

  static Map<String, dynamic>? get user => _user;
  static bool get hasSession => _user != null;
  static String? get userId => _user?['user_id']?.toString() ?? _user?['id']?.toString();

  static Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionKey);
    _user = raw == null ? null : _asMap(raw);
  }

  static Future<void> clearSession() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  static Future<void> _saveSession(Map<String, dynamic> user) async {
    _user = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, json.encode(user));
  }

  /// `username` is whatever the account was registered with — the docs and
  /// live probing show both email and phone accepted here, the server
  /// evidently checks both. `country` is a 2-letter code (defaults to `UG`,
  /// the only country this app currently supports at signup). `gcm` is an
  /// FCM/push token; we don't collect one yet, so it's sent empty.
  static Future<Map<String, dynamic>> signIn(
    String username,
    String password, {
    String country = 'UG',
  }) async {
    final result = await _post('login', {
      'username': username,
      'password': password,
      'country': country,
      'gcm': '',
    });
    if (result['error'] != null) return _failure(result['error'] as String);

    if (_isKnownFailure(result)) {
      return _failure(_message(result, 'Invalid login credentials'));
    }

    final id = result['user_id'];
    if (id != null && '$id'.isNotEmpty) {
      await _saveSession(result);
      return {'success': true, 'user': result};
    }
    // Neither the known failure shape nor a user_id — an unrecognised
    // response. Surface the raw message rather than silently failing.
    return _failure(_message(result, 'Login failed. Please try again.'));
  }

  /// `gender` isn't collected by the current signup form; the server
  /// accepted it blank in testing, so it's sent as `''` unless provided.
  static Future<Map<String, dynamic>> signUp({
    required String username,
    required String email,
    required String phone,
    required String password,
    String gender = '',
    String country = 'UG',
  }) async {
    final result = await _post('addUsers', {
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'gender': gender,
      'gcm': '',
      'country': country,
    });
    if (result['error'] != null) return _failure(result['error'] as String);

    if (_isKnownFailure(result)) {
      return _failure(_message(result, 'Registration failed'));
    }

    final id = result['user_id'];
    if (id != null && '$id'.isNotEmpty) {
      await _saveSession(result);
      return {
        'success': true,
        'user': result,
        // addUsers's message says a verification code was texted to the
        // phone number; the login flow for a freshly-registered, unverified
        // account is not confirmed (see class doc).
        'message': result['message'],
      };
    }
    return _failure(_message(result, 'Registration failed. Please try again.'));
  }

  /// Verifies the SMS code sent by [signUp] and logs the user in.
  /// **Unverified against the live server** — no successful `addUsers` +
  /// `logincode` pair has been observed end to end.
  static Future<Map<String, dynamic>> verifyCode(
    String userId,
    String phone,
    String pin,
  ) async {
    final result = await _post('logincode', {
      'userId': userId,
      'phone': phone,
      'pin': pin,
    });
    if (result['error'] != null) return _failure(result['error'] as String);

    if (_isKnownFailure(result)) {
      return _failure(_message(result, 'Invalid verification code'));
    }
    final id = result['user_id'] ?? userId;
    await _saveSession({...result, 'user_id': id});
    return {'success': true, 'user': result};
  }

  static Future<Map<String, dynamic>> resendCode(String phone) async {
    final result = await _post('resendcode', {'phone': phone});
    if (result['error'] != null) return _failure(result['error'] as String);
    if (_isKnownFailure(result)) {
      return _failure(_message(result, 'Could not resend the code'));
    }
    return {'success': true};
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final result = await _post('forgotPassword', {'email': email});
    if (result['error'] != null) return _failure(result['error'] as String);
    if (_isKnownFailure(result)) {
      return _failure(_message(result, 'No account found for that email'));
    }
    return {'success': true};
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

  /// The only confirmed failure shape across every `cmd` tested so far.
  static bool _isKnownFailure(Map<String, dynamic> result) =>
      '${result['status']}'.toLowerCase() == 'wrong' ||
      '${result['status']}'.toLowerCase() == 'missing';

  static String _message(Map<String, dynamic> result, String fallback) {
    final message = '${result['message'] ?? ''}';
    return message.trim().isEmpty ? fallback : message;
  }

  static Map<String, dynamic> _failure(String error) =>
      {'success': false, 'error': error};

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    if (value is String && value.trim().isNotEmpty) {
      try {
        final decoded = json.decode(value);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    return null;
  }
}
