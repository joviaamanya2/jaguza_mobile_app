// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:jaguza_app/main.dart';
import 'package:jaguza_app/services/api_service.dart';

void main() {
  test('media URLs use the configured API host for local uploads', () {
    final service = ApiService();
    final resolved = Uri.parse(
      service.resolveMediaUrl('http://localhost/storage/media/image.jpg'),
    );

    expect(resolved.host, isNot('localhost'));
    expect(resolved.path, '/storage/media/image.jpg');
    expect(
      service.resolveMediaUrl('https://cdn.example.com/media/image.jpg'),
      'https://cdn.example.com/media/image.jpg',
    );
  });

  testWidgets('app mounts successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MyApp), findsOneWidget);
  });
}
