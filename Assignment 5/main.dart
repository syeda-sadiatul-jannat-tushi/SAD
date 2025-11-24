import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 100, 11, 11),
        scaffoldBackgroundColor: const Color.fromARGB(255, 54, 14, 14),
        useMaterial3: true,
      ),

      home: const HomePage(),
    );
  }
}
