import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warung_sk3/main.dart';

void main() {
  testWidgets('Find 13px overflow with orders', (tester) async {
    for (double w = 250; w <= 1200; w += 25) {
      tester.view.physicalSize = Size(w, 800);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final tambah = find.text('+ Tambah');
      if (tambah.evaluate().isNotEmpty) {
        await tester.tap(tambah.first);
        await tester.pumpAndSettle();
      }
    }
  });
}
