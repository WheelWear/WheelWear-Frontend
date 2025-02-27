import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheelwear_frontend/utils/bodyImageManager/body_image_provider.dart';
import 'features/Fitting/FittingResult/fitting_result_provider.dart';
import 'features/Fitting/fitting_closet/providers/fitting_creation_provider.dart' as fitting;
import 'features/Fitting/fitting_screen.dart';
import 'features/MyPage/mypage_screen.dart';
import 'features/Closet/closet_header_screen.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Closet 관련 provider에 alias 부여
import 'features/Closet/providers/closet_filter_provider.dart' as closet;
import 'features/Closet/providers/selection_provider.dart' as closet;
import 'features/Closet/providers/closet_items_provider.dart' as closet;

// FittingCloset 관련 provider에 alias 부여
import 'features/Fitting/fitting_closet/providers/closet_filter_provider.dart' as fitting;
import 'features/Fitting/fitting_closet/providers/closet_items_provider.dart' as fitting;
import 'features/Fitting/fitting_closet/providers/clothing_confirmation_provider.dart' as fitting;

import 'utils/bodyImageManager/body_service.dart';
import 'features/Fitting/fitting_service.dart';
import 'features/MyPage/profile_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);
  final Color activeColor = Color(0xFF3617CE);
  final Color inactiveColor = Color(0xFF555555);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600; // 아이패드 기준으로 너비 600 이상
    final isLandscape = screenWidth > screenHeight; // 가로 모드 확인

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BodyImageProvider>(
          create: (_) => BodyImageProvider(MyPageService(dio: Dio())),
        ),
        ChangeNotifierProvider<FittingResultProvider>(
          create: (_) => FittingResultProvider(),
        ),
      ],
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
                children: [
            SizedBox(height: isTablet && isLandscape ? 20.0 : 10.0), // 아이패드 가로 모드에서 더 큰 여백
            Expanded(
                child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    children: [
                MultiProvider(
                providers: [
                ChangeNotifierProvider<closet.ClosetFilterProvider>(
                    create: (_) => closet.ClosetFilterProvider(),
          ),
          ChangeNotifierProvider<closet.SelectionProvider>(
            create: (_) => closet.SelectionProvider(),
          ),
          ChangeNotifierProvider<closet.ClosetItemsProvider>(
            create: (_) => closet.ClosetItemsProvider(),
          ),
          ],
          child: ClosetHeaderScreen(),
    ),
    MultiProvider(
    providers: [
    ChangeNotifierProvider<fitting.ClothingConfirmationProvider>(
    create: (_) => fitting.ClothingConfirmationProvider(),
    ),
    ChangeNotifierProvider<fitting.ClosetItemsProvider>(
    create: (_) => fitting.ClosetItemsProvider(),
    ),
    ChangeNotifierProvider<fitting.FittingCreationProvider>(
    create: (_) => fitting.FittingCreationProvider(),
    ),
    ],
    child: FittingScreen(),
    ),
    MultiProvider(
    providers: [
    ChangeNotifierProvider<ProfileProvider>(
    create: (_) => ProfileProvider(),
    ),
    ],
    child: MyPageScreen(),
    ),
    ],
    ),
    ),
    CupertinoTabBar(
    backgroundColor: CupertinoColors.white,
    activeColor: activeColor,
    inactiveColor: inactiveColor,
    height: isTablet ? 80.0 : 70.0, // 아이패드에서는 탭바 높이 조금 더 크게
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
    ),
    ),
    );
  }

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

  TextStyle _tabTextStyle() {
    return TextStyle(
      fontSize: 12,
      color: CupertinoColors.black,
      fontWeight: FontWeight.w400,
    );
  }
}