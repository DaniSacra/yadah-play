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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
