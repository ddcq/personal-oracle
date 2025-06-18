import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'utils/themes.dart';

void main() {
  runApp(const OracleNordiqueApp());
}

class OracleNordiqueApp extends StatelessWidget {
  const OracleNordiqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oracle Nordique',
      theme: AppThemes.darkTheme,
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}