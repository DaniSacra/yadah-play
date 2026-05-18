import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

import '../repositories/hymn_state.dart';
import '../screens/home_screen.dart';
import '../theme/app_theme.dart';
import '../theme_mode_notifier.dart';
import '../upgrader/app_upgrader_config.dart';

/// Raiz do app: navegação, tema, upgrader e providers.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final Upgrader _upgrader = createAppUpgrader();

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
            navigatorKey: _navigatorKey,
            title: 'Hinário',
            debugShowCheckedModeBanner: false,
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            themeMode: themeModeNotifier.mode,
            home: UpgradeAlert(
              navigatorKey: _navigatorKey,
              upgrader: _upgrader,
              showIgnore: false,
              showLater: false,
              child: HomeScreen(upgrader: _upgrader),
            ),
          );
        },
      ),
    );
  }
}
