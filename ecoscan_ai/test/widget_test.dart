import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecoscan_ai/main.dart';

void main() {
  testWidgets('EcoScanApp renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const EcoScanApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
