import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 1.3: Flutter Widgets',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Explore Flutter Widgets'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.blue[50], // Màu nền của Container
              borderRadius: BorderRadius.circular(15), // Bo góc Container
              border: Border.all(color: Colors.blue, width: 2), // Viền
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Text Widget
                const Text(
                  'Hello, Flutter!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 20), // Khoảng cách
                
                // 2. Image Widget
                Image.asset(
                  'assets/images/flutter_logo.png',
                  width: 150,
                  height: 150,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}