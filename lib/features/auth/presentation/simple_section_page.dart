import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SimpleSectionPage extends StatelessWidget {
  final String title;
  const SimpleSectionPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      appBar: AppBar(
        backgroundColor: const Color(0xFF18181C),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Text(
          'Welcome to the $title section',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
