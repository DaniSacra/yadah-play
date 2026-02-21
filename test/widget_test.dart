// Teste básico do app Hinário.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yadah_play/main.dart';
import 'package:yadah_play/repositories/hymn_state.dart';
import 'package:yadah_play/screens/recent_hymns_screen.dart';

import 'helpers.dart';

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

  testWidgets('Home exibe ícone de histórico', (WidgetTester tester) async {
    await tester.pumpWidget(const YadahPlayApp());
    await tester.pump();

    expect(find.byIcon(Icons.history), findsOneWidget);
  });

  testWidgets('RecentHymnsScreen exibe título e lista quando há recentes', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = HymnState(repository: FakeHymnRepository(sampleHymns));
    await state.loadHymns();
    await state.addToRecentHymns(sampleHymns[0]);
    await state.addToRecentHymns(sampleHymns[1]);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<HymnState>.value(
          value: state,
          child: const RecentHymnsScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Últimos hinos visualizados'), findsOneWidget);
    expect(find.text('Noite de Paz'), findsOneWidget);
    expect(find.text('Castelo Forte'), findsOneWidget);
  });

  testWidgets('RecentHymnsScreen exibe mensagem vazia quando não há recentes', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = HymnState(repository: FakeHymnRepository(sampleHymns));
    await state.loadHymns();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<HymnState>.value(
          value: state,
          child: const RecentHymnsScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Últimos hinos visualizados'), findsOneWidget);
    expect(find.text('Nenhum hino visualizado ainda.'), findsOneWidget);
  });
}
