import 'package:flutter/material.dart';

import 'part1.dart';
import 'part2.dart';
import 'part3.dart';
import 'part4.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Danh sách các màn hình được lấy từ các file riêng
  final List<Widget> _screens = const [
    LayoutApp(),
    ResponsiveHomePage(),
    NavigationApp(),
    FormApp(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.looks_one), label: 'Part 1'),
          BottomNavigationBarItem(icon: Icon(Icons.looks_two), label: 'Part 2'),
          BottomNavigationBarItem(icon: Icon(Icons.looks_3), label: 'Part 3'),
          BottomNavigationBarItem(icon: Icon(Icons.looks_4), label: 'Part 4'),
        ],
      ),
    );
  }
}