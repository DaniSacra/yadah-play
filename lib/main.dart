import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repositories/hymn_state.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const YadahPlayApp());
}

class YadahPlayApp extends StatelessWidget {
  const YadahPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HymnState(),
      child: MaterialApp(
        title: 'Hinário',
        debugShowCheckedModeBanner: false,
        theme: () {
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
        }(),
        home: const HomeScreen(),
      ),
    );
  }
}
