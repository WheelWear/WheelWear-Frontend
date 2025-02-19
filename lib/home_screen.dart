import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'features/Fitting/fitting_screen.dart';
import 'features/MyPage/mypage_screen.dart';
import 'features/Closet/closet_header_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  final Color activeColor = Color(0xFF3617CE);
  final Color inactiveColor = Color(0xFF555555);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: [
                ClosetHeaderScreen(),
                FittingScreen(),
                MyPageScreen(),
              ],
            ),
          ),
          CupertinoTabBar(
            backgroundColor: CupertinoColors.white,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            height: 70,
            items: [
              BottomNavigationBarItem(
                icon: _buildTabItem(0, CupertinoIcons.square_grid_2x2, "옷장"),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _buildTabItem(1, CupertinoIcons.house, "피팅룸"),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _buildTabItem(2, CupertinoIcons.person, "마이페이지"),
                label: '',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ],
      ),
    );
  }

  // 선택된 탭의 아이콘 및 슬라이딩 바 적용
  Widget _buildTabItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: isSelected ? 4 : 0,
          width: isSelected ? 30 : 0,
          decoration: BoxDecoration(
            color: activeColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 4),
        Icon(
          icon,
          size: 23,
          color: isSelected ? activeColor : inactiveColor,
        ),
        SizedBox(height: 2),
        Text(label, style: _tabTextStyle()),
      ],
    );
  }

  // 글씨 스타일
  TextStyle _tabTextStyle() {
    return TextStyle(
      fontSize: 12,
      color: CupertinoColors.black,
      fontWeight: FontWeight.w400,
    );
  }
}


