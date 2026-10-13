import 'package:flutter_test/flutter_test.dart';

import 'package:interaktif/main.dart';

void main() {
  testWidgets('EcoLife home page loads', (WidgetTester tester) async {
    await tester.pumpWidget(const EnergiKuApp());

    expect(find.text('EcoLife'), findsOneWidget);
    expect(find.text('Halo, Teman Hijau!'), findsOneWidget);
    expect(find.text('250'), findsOneWidget);
  });
}
