import 'package:upgrader/upgrader.dart';

import 'upgrader_debug.dart';

/// Diagnóstico ativo: painel na home + popup de atualização sempre + logs.
/// Defina `false` antes do release final para usuários.
const bool kShowUpgraderDebugPanel = true;

const _playStoreCountry = 'br';
const _language = 'pt';
const _alertCooldown = Duration(days: 1);

/// Cria o [Upgrader] do app com configuração única (DRY).
Upgrader createAppUpgrader() {
  return Upgrader(
    languageCode: _language,
    countryCode: _playStoreCountry,
    durationUntilAlertAgain: _alertCooldown,
    debugDisplayAlways: kShowUpgraderDebugPanel,
    debugLogging: kShowUpgraderDebugPanel,
    willDisplayUpgrade: UpgraderDebugTrace.record,
  );
}
