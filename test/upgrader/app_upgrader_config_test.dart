import 'package:flutter_test/flutter_test.dart';
import 'package:yadah_play/upgrader/app_upgrader_config.dart';

void main() {
  test('createAppUpgrader aplica país BR, idioma PT e flags de diagnóstico', () {
    final upgrader = createAppUpgrader();

    expect(upgrader.state.countryCodeOverride, 'br');
    expect(upgrader.state.languageCodeOverride, 'pt');
    expect(upgrader.state.debugDisplayAlways, kShowUpgraderDebugPanel);
    expect(upgrader.state.debugLogging, kShowUpgraderDebugPanel);
  });
}
