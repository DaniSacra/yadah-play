import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

import 'repositories/hymn_state.dart';
import 'screens/home_screen.dart';
import 'theme_mode_notifier.dart';

void main() {
  runApp(const YadahPlayApp());
}

ThemeData _buildLightTheme() {
  const blue = Color(0xFF0F49BD);
  final scheme = ColorScheme.fromSeed(
    seedColor: blue,
    brightness: Brightness.light,
  ).copyWith(
    primary: blue,
    surface: const Color(0xFFF6F6F8),
    surfaceContainerLowest: Colors.white,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: scheme.primary,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: scheme.primary,
      side: BorderSide(color: scheme.outlineVariant),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}

ThemeData _buildDarkTheme() {
  // Azul mais claro no dark para boa leitura (Material Blue 300).
  const primaryDark = Color(0xFF64B5F6);
  final scheme = ColorScheme.fromSeed(
    seedColor: primaryDark,
    brightness: Brightness.dark,
  ).copyWith(
    primary: primaryDark,
    onPrimary: const Color(0xFF003258),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      iconTheme: IconThemeData(color: scheme.onSurface),
      actionsIconTheme: IconThemeData(color: scheme.onSurface),
      titleTextStyle: TextStyle(
        color: scheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHigh,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    cardTheme: CardTheme(
      color: scheme.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: scheme.surfaceContainerHigh,
      selectedColor: scheme.primary,
      side: BorderSide(color: scheme.outlineVariant),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}

class YadahPlayApp extends StatelessWidget {
  const YadahPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HymnState()),
        ChangeNotifierProvider(create: (_) => ThemeModeNotifier()..load()),
      ],
      child: Consumer<ThemeModeNotifier>(
        builder: (context, themeModeNotifier, _) {
          return MaterialApp(
            title: 'Hinário',
            debugShowCheckedModeBanner: false,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: themeModeNotifier.mode,
            // Ao publicar nova versão na Play Store, quem está em versão antiga
            // vê o aviso e o botão "Atualizar" abre a loja. Para forçar (sem
            // "Depois"/"Ignorar"), adicione na descrição da loja:
            // [Minimum supported app version: 2.0.0]
            home: UpgradeAlert(
              upgrader: Upgrader(
                languageCode: 'pt',
                durationUntilAlertAgain: const Duration(days: 1),
                // Em debug o diálogo aparece sempre (para testar). Em release, só quando há versão nova na loja.
                debugDisplayAlways: kDebugMode,
              ),
              showIgnore: false,
              showLater: false,
              child: const HomeScreen(),
            ),
          );
        },
      ),
    );
  }
}
