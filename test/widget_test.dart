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

  testWidgets('Home exibe campo de pesquisa com placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(const YadahPlayApp());
    await tester.pump();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Pesquisar por número ou título...'), findsOneWidget);
  });

  testWidgets('Home exibe ícone de tema (dark/light mode)', (WidgetTester tester) async {
    await tester.pumpWidget(const YadahPlayApp());
    await tester.pump();

    expect(find.byIcon(Icons.dark_mode), findsOneWidget);
  });
}
