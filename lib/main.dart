import 'package:flutter/material.dart';
import 'package:nurtura_grow/screens/auth/auth_screen.dart';
import 'package:nurtura_grow/screens/auth/register_screen.dart';

import 'package:nurtura_grow/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: AppTheme.projectTheme,
      home: const AuthScreen(),
    );
  }
}