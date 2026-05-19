import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:yadah_play/services/in_app_update_service.dart';

AppUpdateInfo _fakeInfo(UpdateAvailability availability) => AppUpdateInfo(
      updateAvailability: availability,
      immediateUpdateAllowed: availability == UpdateAvailability.updateAvailable,
      immediateAllowedPreconditions: null,
      flexibleUpdateAllowed: availability == UpdateAvailability.updateAvailable,
      flexibleAllowedPreconditions: null,
      availableVersionCode: null,
      installStatus: InstallStatus.unknown,
      packageName: 'br.com.d3lab.yadahplay',
      clientVersionStalenessDays: null,
      updatePriority: 0,
    );

void main() {
  group('showUpdateAvailableDialog', () {
    testWidgets('exibe título e botões', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => TextButton(
              onPressed: () => showUpdateAvailableDialog(ctx),
              child: const Text('open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Nova versão disponível'), findsOneWidget);
      expect(find.text('Atualizar'), findsOneWidget);
      expect(find.text('Depois'), findsOneWidget);
    });

    testWidgets('botão Depois fecha o diálogo', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => TextButton(
              onPressed: () => showUpdateAvailableDialog(ctx),
              child: const Text('open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Depois'));
      await tester.pumpAndSettle();

      expect(find.text('Nova versão disponível'), findsNothing);
    });
  });

  group('checkAndPromptUpdate', () {
    testWidgets('exibe diálogo quando atualização disponível', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => TextButton(
              onPressed: () => checkAndPromptUpdate(
                ctx,
                checker: () async => _fakeInfo(UpdateAvailability.updateAvailable),
              ),
              child: const Text('check'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('check'));
      await tester.pumpAndSettle();

      expect(find.text('Nova versão disponível'), findsOneWidget);
    });

    testWidgets('não exibe diálogo quando não há atualização', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => TextButton(
              onPressed: () => checkAndPromptUpdate(
                ctx,
                checker: () async => _fakeInfo(UpdateAvailability.updateNotAvailable),
              ),
              child: const Text('check'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('check'));
      await tester.pumpAndSettle();

      expect(find.text('Nova versão disponível'), findsNothing);
    });

    testWidgets('não trava quando checker lança exceção', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => TextButton(
              onPressed: () => checkAndPromptUpdate(
                ctx,
                checker: () async => throw Exception('sem Play Services'),
              ),
              child: const Text('check'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('check'));
      await tester.pumpAndSettle();

      expect(find.text('Nova versão disponível'), findsNothing);
    });
  });
}
