import 'package:flutter/material.dart';
import 'package:sad/converter_page.dart';
import 'package:sad/listview_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_page.dart';
import 'package:sad/auth/auth_gate.dart';

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
      // theme: ThemeData.dark(),
      home: AuthGate(),
    );
  }
}
