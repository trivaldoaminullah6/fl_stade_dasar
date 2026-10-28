import 'package:flutter_test/flutter_test.dart';
import 'package:isd_flutter/main.dart';

void main() {
  testWidgets('Profile smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Kartu Profil Digital'), findsOneWidget);
  });
}
