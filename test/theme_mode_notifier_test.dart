import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadah_play/theme_mode_notifier.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ThemeModeNotifier', () {
    test('modo inicial é light', () {
      final notifier = ThemeModeNotifier();
      expect(notifier.mode, ThemeMode.light);
    });

    test('load() mantém light quando prefs não tem dark_mode', () async {
      final notifier = ThemeModeNotifier();
      await notifier.load();
      expect(notifier.mode, ThemeMode.light);
    });

    test('load() aplica dark quando prefs tem dark_mode true', () async {
      SharedPreferences.setMockInitialValues({'dark_mode': true});
      final notifier = ThemeModeNotifier();
      await notifier.load();
      expect(notifier.mode, ThemeMode.dark);
    });

    test('toggle() alterna de light para dark', () async {
      final notifier = ThemeModeNotifier();
      await notifier.toggle();
      expect(notifier.mode, ThemeMode.dark);
    });

    test('toggle() alterna de dark para light', () async {
      SharedPreferences.setMockInitialValues({'dark_mode': true});
      final notifier = ThemeModeNotifier();
      await notifier.load();
      expect(notifier.mode, ThemeMode.dark);
      await notifier.toggle();
      expect(notifier.mode, ThemeMode.light);
    });

    test('toggle() notifica listeners', () async {
      final notifier = ThemeModeNotifier();
      var notified = false;
      notifier.addListener(() => notified = true);
      await notifier.toggle();
      expect(notified, true);
    });
  });
}
