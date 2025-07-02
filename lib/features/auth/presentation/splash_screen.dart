import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF101014),
      body: Center(
        child: CircularProgressIndicator(color: Colors.amber),
      ),
    );
  }
}
