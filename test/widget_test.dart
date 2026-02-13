// Teste básico do app Hinário.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yadah_play/main.dart';

void main() {
  testWidgets('App inicia com título Hinário', (WidgetTester tester) async {
    await tester.pumpWidget(const YadahPlayApp());
    await tester.pump();

    expect(find.text('Hinário'), findsOneWidget);
  });
}
