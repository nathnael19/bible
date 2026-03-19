import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bible/main.dart';
import 'package:bible/core/di/injection_container.dart';

void main() {
  setUpAll(() async {
    await initDependencies();
  });

  testWidgets('App smoke test — renders without throwing', (tester) async {
    await tester.pumpWidget(const BibleApp());
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
