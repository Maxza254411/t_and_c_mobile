import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/favoritePage.dart';
import 'package:t_and_c_mobile/homepage.dart';
import 'package:t_and_c_mobile/order/history.dart';
import 'package:t_and_c_mobile/povider/favoriteProvider.dart';
import 'package:t_and_c_mobile/profile.dart';

class FirstPage extends StatefulWidget {
  FirstPage({super.key, this.profile});

  @override
  State<FirstPage> createState() => _FirstPageState();
  int? profile;
}

class _FirstPageState extends State<FirstPage> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.profile == null) {
        _currentIndex = 0;
        setState(() {});
      } else {
        _currentIndex = widget.profile!;
        setState(() {});
      }
    });
  }

  // สร้างหน้าที่จะแสดงเมื่อกด bottom nav
  final List<Widget> _pages = [
    HomePage(),
    FavoritePage(),
    History(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // 👈 สำคัญ
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        selectedItemColor: kButtonColor,
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
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  _currentIndex == 1
                      ? "assets/icons/love.png"
                      : "assets/icons/lovef.png",
                  width: 24,
                  height: 24,
                ),

                // Badge (มุมขวาบน)
                Consumer<FavoriteProvider>(
                  builder: (context, favProvider, child) {
                    if (favProvider.favorites.isEmpty) {
                      return SizedBox.shrink(); // ไม่มีสินค้า -> ไม่แสดงอะไร
                    }
                    return Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            favProvider.favorites.length
                                .toString(), // จำนวนสินค้า
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
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
