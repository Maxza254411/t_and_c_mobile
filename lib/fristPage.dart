import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/homepage.dart';
import 'package:t_and_c_mobile/profile.dart';

class FirstPage extends StatefulWidget {
   FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _currentIndex = 0;

  // สร้างหน้าที่จะแสดงเมื่อกด bottom nav
  final List<Widget> _pages = [
    HomePage(),
    HomePage(),
    HomePage(), 
    Profile(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbgM,
      body: _pages[_currentIndex], 
      bottomNavigationBar: BottomNavigationBar(
       backgroundColor: Colors.white, 
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
              _currentIndex == 0
                  ? "assets/icons/Home.png"
                  : "assets/icons/HomF.png",
              width: 24,
              height: 24,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 1
                  ? "assets/icons/love.png"
                  : "assets/icons/lovef.png",
              width: 24,
              height: 24,
            ),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 2
                  ? "assets/icons/Paper.png"
                  : "assets/icons/PaperF.png",
              width: 24,
              height: 24,
            ),
            label: "History",
          ),
           BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 3
                  ? "assets/icons/Profile.png"
                  : "assets/icons/ProfileF.png",
              width: 24,
              height: 24,
            ),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
