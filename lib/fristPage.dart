import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/homepage.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _currentIndex = 0;

  // สร้างหน้าที่จะแสดงเมื่อกด bottom nav
  final List<Widget> _pages = [
    HomePage(),
    HomePage(),
    HomePage(), // หน้าแรก
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // เปลี่ยนตาม index
      bottomNavigationBar: BottomNavigationBar(
  currentIndex: _currentIndex,
  selectedItemColor: Colors.blue,
  unselectedItemColor: Colors.grey,
  onTap: (index) {
    setState(() {
      _currentIndex = index;
    });
  },
  items: [
    BottomNavigationBarItem(
      icon: Image.asset(
        "assets/icons/home.png",
        width: 24,
        height: 24,
      ),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Image.asset(
        "assets/icons/search.png",
        width: 24,
        height: 24,
      ),
      label: "Search",
    ),
    BottomNavigationBarItem(
      icon: Image.asset(
        "assets/icons/profile.png",
        width: 24,
        height: 24,
      ),
      label: "Profile",
    ),
  ],
),

    );
  }
}
