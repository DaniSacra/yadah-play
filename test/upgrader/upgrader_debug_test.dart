import 'package:flutter_test/flutter_test.dart';
import 'package:upgrader/upgrader.dart';
import 'package:yadah_play/upgrader/upgrader_debug.dart';

void main() {
  setUp(UpgraderDebugTrace.reset);

  group('UpgraderDebugTrace', () {
    test('record formata callback willDisplayUpgrade', () {
      UpgraderDebugTrace.record(
        display: true,
        installedVersion: '1.0.0',
        versionInfo: UpgraderVersionInfo(releaseNotes: 'novidades'),
      );

      expect(
        UpgraderDebugTrace.lastWillDisplay,
        'willDisplayUpgrade: true | instalada: 1.0.0 | loja: null',
      );
    });

    test('reset limpa trace', () {
      UpgraderDebugTrace.record(display: false);
      UpgraderDebugTrace.reset();
      expect(UpgraderDebugTrace.lastWillDisplay, isNull);
    });
  });

  group('UpgraderDebugSnapshot', () {
    test('toReport inclui campos principais', () {
      final snap = UpgraderDebugSnapshot(
        at: DateTime(2025, 1, 1, 12),
        initOk: true,
        mode: 'produção',
        os: 'android',
        packageName: 'br.com.d3lab.yadahplay',
        appName: 'Hinário',
        installedVersion: '1.8.0',
        buildNumber: '10',
        storeVersion: '1.9.0',
        countryCode: 'br',
        languageCode: 'pt',
        debugDisplayAlways: false,
        debugLogging: true,
        isUpdateAvailable: true,
        shouldDisplayUpgrade: true,
        isTooSoon: false,
        alreadyIgnoredVersion: false,
        belowMinAppVersion: false,
        playStoreLookupHint: 'Lookup OK',
      );

      final report = snap.toReport();
      expect(report, contains('br.com.d3lab.yadahplay'));
      expect(report, contains('1.8.0'));
      expect(report, contains('1.9.0'));
      expect(report, contains('isUpdateAvailable: true'));
      expect(report, contains('shouldDisplayUpgrade: true'));
    });
  });

  group('buildUpgraderDebugSnapshot', () {
    test('sem packageInfo usa placeholders', () {
      final upgrader = Upgrader(debugLogging: false);
      final snap = buildUpgraderDebugSnapshot(upgrader, initOk: false, error: 'falha init');

      expect(snap.packageName, '(sem packageInfo)');
      expect(snap.installedVersion, '?');
      expect(snap.error, 'falha init');
      expect(snap.isUpdateAvailable, isFalse);
    });
  });
}
