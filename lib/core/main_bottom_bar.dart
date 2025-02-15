import 'package:flutter/cupertino.dart';
import '../features/closet/closet_screen.dart';
import '../features/fitting/fitting_screen.dart';
import '../features/MyPage/mypage_screen.dart';

class AppTabScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: CupertinoColors.activeBlue,
        inactiveColor: CupertinoColors.black,
        backgroundColor: CupertinoColors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bag),
            label: "옷장",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: "피팅룸",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: "마이",
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return ClosetScreen();
          // case 1:
          //   return FittingRoomScreen();
          // case 2:
          //   return ProfileScreen();
          default:
            return ClosetScreen();
        }
      },
    );
  }
}

// 임시 클래스

class ProfileScreen {
}

class FittingRoomScreen {
}
