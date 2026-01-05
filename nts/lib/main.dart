import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sad/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth/auth_gate.dart'; // Your existing AuthGate

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://pioeyguobwzgmeixguyd.supabase.co",
    anonKey: "sb_publishable_xUkXJXsZOe6_iG2Ls0vV_g_YLpcWTpz",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Marvels',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const SplashScreen(), // Start with SplashScreen
    );
  }
}
