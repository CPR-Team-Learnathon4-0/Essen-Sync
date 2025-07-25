import 'package:flutter/material.dart';
import 'dart:async';
import 'pages/home_page.dart';
import 'pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Essen-Sync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: const SplashScreen(),
    );
  }
}
