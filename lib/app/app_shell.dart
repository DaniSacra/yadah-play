import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/hymn_state.dart';
import '../screens/home_screen.dart';
import '../theme/app_theme.dart';
import '../theme_mode_notifier.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HymnState()),
        ChangeNotifierProvider(create: (_) => ThemeModeNotifier()..load()),
      ],
      child: Consumer<ThemeModeNotifier>(
        builder: (_, themeModeNotifier, __) => MaterialApp(
          title: 'Hinário',
          debugShowCheckedModeBanner: false,
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: themeModeNotifier.mode,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
