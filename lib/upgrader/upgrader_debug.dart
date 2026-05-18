import 'package:upgrader/upgrader.dart';

/// Último callback [Upgrader.willDisplayUpgrade] (só para diagnóstico).
class UpgraderDebugTrace {
  static String? lastWillDisplay;

  static void record({
    required bool display,
    String? installedVersion,
    UpgraderVersionInfo? versionInfo,
  }) {
    lastWillDisplay =
        'willDisplayUpgrade: $display | instalada: $installedVersion | loja: ${versionInfo?.appStoreVersion}';
  }

  /// Limpa entre testes.
  static void reset() => lastWillDisplay = null;
}

/// Estado legível do [Upgrader] para o painel de debug.
class UpgraderDebugSnapshot {
  final DateTime at;
  final bool initOk;
  final String? error;
  final String mode;
  final String os;
  final String packageName;
  final String appName;
  final String installedVersion;
  final String buildNumber;
  final String? storeVersion;
  final String? storeListingUrl;
  final String? minAppVersionFromStore;
  final String? minAppVersionConfig;
  final String countryCode;
  final String languageCode;
  final bool debugDisplayAlways;
  final bool debugLogging;
  final bool isUpdateAvailable;
  final bool shouldDisplayUpgrade;
  final bool isTooSoon;
  final bool alreadyIgnoredVersion;
  final bool belowMinAppVersion;
  final String? releaseNotesPreview;
  final String? willDisplayTrace;
  final String playStoreLookupHint;

  const UpgraderDebugSnapshot({
    required this.at,
    required this.initOk,
    this.error,
    required this.mode,
    required this.os,
    required this.packageName,
    required this.appName,
    required this.installedVersion,
    required this.buildNumber,
    this.storeVersion,
    this.storeListingUrl,
    this.minAppVersionFromStore,
    this.minAppVersionConfig,
    required this.countryCode,
    required this.languageCode,
    required this.debugDisplayAlways,
    required this.debugLogging,
    required this.isUpdateAvailable,
    required this.shouldDisplayUpgrade,
    required this.isTooSoon,
    required this.alreadyIgnoredVersion,
    required this.belowMinAppVersion,
    this.releaseNotesPreview,
    this.willDisplayTrace,
    required this.playStoreLookupHint,
  });

  String toReport() {
    final lines = <String>[
      '=== Upgrader debug (${at.toIso8601String()}) ===',
      'Modo: $mode',
      'SO: $os',
      'Pacote: $packageName',
      'App: $appName',
      'Instalada (versionName): $installedVersion',
      'Build (versionCode): $buildNumber',
      'Loja (Play): ${storeVersion ?? "(não obtida)"}',
      'URL loja: ${storeListingUrl ?? "(n/a)"}',
      'minAppVersion (loja): ${minAppVersionFromStore ?? "(n/a)"}',
      'minAppVersion (config): ${minAppVersionConfig ?? "(n/a)"}',
      'País (lookup): $countryCode | Idioma: $languageCode',
      'debugDisplayAlways: $debugDisplayAlways | debugLogging: $debugLogging',
      'isUpdateAvailable: $isUpdateAvailable',
      'shouldDisplayUpgrade: $shouldDisplayUpgrade',
      'isTooSoon (cooldown): $isTooSoon',
      'alreadyIgnoredThisVersion: $alreadyIgnoredVersion',
      'belowMinAppVersion: $belowMinAppVersion',
      willDisplayTrace ?? 'willDisplayUpgrade: (ainda não chamado)',
      'Play Store: $playStoreLookupHint',
      if (releaseNotesPreview != null) 'Release notes: $releaseNotesPreview',
      if (error != null) 'ERRO: $error',
    ];
    return lines.join('\n');
  }
}

/// Monta snapshot a partir do [upgrader] (testável sem rede se já inicializado).
UpgraderDebugSnapshot buildUpgraderDebugSnapshot(
  Upgrader upgrader, {
  DateTime? at,
  bool initOk = true,
  String? error,
}) {
  final pkg = upgrader.state.packageInfo;
  final locale = upgrader.findLocale();
  final vi = upgrader.versionInfo;
  final notes = upgrader.releaseNotes;
  final storeVersion = upgrader.currentAppStoreVersion;
  final installed = upgrader.currentInstalledVersion ?? '?';

  return UpgraderDebugSnapshot(
    at: at ?? DateTime.now(),
    initOk: initOk,
    error: error,
    mode: upgrader.state.debugDisplayAlways ? 'debugDisplayAlways' : 'produção',
    os: upgrader.state.upgraderOS.currentOSType.name,
    packageName: pkg?.packageName ?? '(sem packageInfo)',
    appName: pkg?.appName ?? '',
    installedVersion: installed,
    buildNumber: pkg?.buildNumber ?? '?',
    storeVersion: storeVersion,
    storeListingUrl: upgrader.currentAppStoreListingURL,
    minAppVersionFromStore: vi?.minAppVersion?.toString(),
    minAppVersionConfig: upgrader.state.minAppVersion?.toString(),
    countryCode:
        upgrader.state.countryCodeOverride ?? upgrader.findCountryCode(locale: locale) ?? 'US',
    languageCode:
        upgrader.state.languageCodeOverride ?? upgrader.findLanguageCode(locale: locale) ?? 'en',
    debugDisplayAlways: upgrader.state.debugDisplayAlways,
    debugLogging: upgrader.state.debugLogging,
    isUpdateAvailable: upgrader.isUpdateAvailable(),
    shouldDisplayUpgrade: upgrader.shouldDisplayUpgrade(),
    isTooSoon: upgrader.isTooSoon(),
    alreadyIgnoredVersion: upgrader.alreadyIgnoredThisVersion(),
    belowMinAppVersion: upgrader.belowMinAppVersion(),
    releaseNotesPreview: _preview(notes),
    willDisplayTrace: UpgraderDebugTrace.lastWillDisplay,
    playStoreLookupHint: storeVersion == null
        ? 'Falha ao ler versão na Play (app publicado? país ${upgrader.state.countryCodeOverride ?? "auto"}?)'
        : 'Lookup OK — comparar instalada ($installed) vs loja ($storeVersion)',
  );
}

String? _preview(String? text, {int maxLen = 120}) {
  if (text == null) return null;
  return text.length > maxLen ? '${text.substring(0, maxLen)}…' : text;
}

/// Inicializa o upgrader e coleta diagnóstico (rede na consulta à Play Store).
Future<UpgraderDebugSnapshot> collectUpgraderDebug(Upgrader upgrader) async {
  var initOk = false;
  String? error;

  try {
    initOk = await upgrader.initialize();
  } catch (e, st) {
    error = '$e\n$st';
  }

  try {
    await upgrader.updateVersionInfo();
  } catch (e) {
    error = error == null ? '$e' : '$error\nupdateVersionInfo: $e';
  }

  if (!initOk && error == null) {
    error = 'initialize() retornou false';
  }
  return buildUpgraderDebugSnapshot(upgrader, initOk: initOk, error: error);
}
