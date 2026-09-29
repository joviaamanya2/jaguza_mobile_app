import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jaguza_app/services/legacy_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Run with:
//   flutter test test/legacy_auth_service_test.dart \
//     --dart-define=LEGACY_API_BASE_URL=http://127.0.0.1:8765/
//
// The mock server below only reproduces the *failure* shapes confirmed live
// against https://jaguzalivestockug.com/mobileapp/api/ on 2026-09-29
// (`status: "wrong"` / `"missing"`) plus a plausible, UNVERIFIED success
// shape (a bare `user_id` alongside other fields, mirroring the confirmed
// `addUsers` success response). If the real `login` success shape turns out
// to differ, update both the mock here and `LegacyAuthService._isKnownFailure`
// / the `user_id` check.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late HttpServer server;
  final received = <String, Map<String, String>>{};

  setUpAll(() async {
    HttpOverrides.global = null; // allow real loopback sockets
    server = await HttpServer.bind('127.0.0.1', 8765);
    server.listen((req) async {
      final body = Uri.splitQueryString(await utf8.decoder.bind(req).join());
      final cmd = body['cmd'];
      received[cmd!] = body;
      Object reply;
      switch (cmd) {
        case 'login':
          if (body['username'] == 'ok@x.com' && body['password'] == 'secret1') {
            reply = {
              'status': 'ok',
              'user_id': '42',
              'name': 'Amina',
              'email': 'ok@x.com',
            };
          } else {
            reply = {
              'status': 'wrong',
              'message': 'Login failed, wrong user name or password',
            };
          }
          break;
        case 'addUsers':
          if (body['email'] == 'dup@x.com') {
            reply = {'status': 'wrong', 'message': 'Email already exists'};
          } else if ((body['username'] ?? '').isEmpty) {
            reply = {'status': 'missing', 'message': 'Incorrect request!'};
          } else {
            reply = {
              'status': 'ok',
              'user_id': '4010',
              'name': body['username'],
              'email': body['email'],
              'phone': body['phone'],
              'role': '4',
              'acctype': 'normaluser',
              'message':
                  'User has been registered successfully. A verification code has been sent to ${body['phone']}',
            };
          }
          break;
        case 'forgotPassword':
          reply = body['email'] == 'known@x.com'
              ? {'status': 'ok'}
              : {'status': 'wrong'};
          break;
        default:
          reply = {'status': 'wrong', 'message': 'Unknown cmd'};
      }
      req.response.headers.contentType = ContentType.json;
      req.response.write(jsonEncode(reply));
      await req.response.close();
    });
  });

  tearDownAll(() => server.close(force: true));
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LegacyAuthService.clearSession();
  });

  test('base url points at the test server', () {
    expect(LegacyAuthService.baseUrl, 'http://127.0.0.1:8765/');
  });

  test('sign in success stores session and posts documented fields', () async {
    final r = await LegacyAuthService.signIn('ok@x.com', 'secret1');
    expect(r['success'], true);
    expect(LegacyAuthService.userId, '42');
    expect(received['login'], {
      'cmd': 'login',
      'username': 'ok@x.com',
      'password': 'secret1',
      'country': 'UG',
      'gcm': '',
    });
    // survives a reload
    await LegacyAuthService.loadSession();
    expect(LegacyAuthService.hasSession, true);
  });

  test('sign in with wrong credentials fails with the server message, no session',
      () async {
    final r = await LegacyAuthService.signIn('bad@x.com', 'nope');
    expect(r['success'], false);
    expect(r['error'], 'Login failed, wrong user name or password');
    expect(LegacyAuthService.hasSession, false);
  });

  test('sign up sends the documented fields and stores a session', () async {
    final r = await LegacyAuthService.signUp(
      username: 'newuser',
      email: 'new@x.com',
      phone: '+256700000000',
      password: 'pw1234',
    );
    expect(r['success'], true);
    expect(LegacyAuthService.userId, '4010');
    expect(received['addUsers'], {
      'cmd': 'addUsers',
      'username': 'newuser',
      'email': 'new@x.com',
      'phone': '+256700000000',
      'password': 'pw1234',
      'gender': '',
      'gcm': '',
      'country': 'UG',
    });
  });

  test('sign up with a duplicate email surfaces the server message', () async {
    final r = await LegacyAuthService.signUp(
      username: 'x', email: 'dup@x.com', phone: '1', password: 'pw',
    );
    expect(r['success'], false);
    expect(r['error'], 'Email already exists');
    expect(LegacyAuthService.hasSession, false);
  });

  test('forgot password reports failure for an unknown email', () async {
    final r = await LegacyAuthService.forgotPassword('nobody@x.com');
    expect(r['success'], false);
  });
}
