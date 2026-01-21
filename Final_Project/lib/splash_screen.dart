import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'auth/auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Random _random = Random();
  final int numStars = 20; 
  late List<double> _starX;
  late List<double> _starY;

  @override
  void initState() {
    super.initState();

    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

   
    _starX = List.generate(numStars, (_) => _random.nextDouble());
    _starY = List.generate(numStars, (_) => _random.nextDouble());

   
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthGate()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildStar(double x, double y) {
    return Positioned(
      left: MediaQuery.of(context).size.width * x,
      top: MediaQuery.of(context).size.height * y,
      child: Icon(
        Icons.star,
        color: Colors.yellowAccent.withOpacity(0.7),
        size: 15 + _random.nextDouble() * 10, 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[400],
      body: Stack(
        children: [
          // Glitter stars
          for (int i = 0; i < numStars; i++) buildStar(_starX[i], _starY[i]),

          // Center logo and text
          Center(
            child: ScaleTransition(
              scale: _animation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/baby_icon1.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Mini Marvels",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 5,
                          color: Colors.pinkAccent,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
