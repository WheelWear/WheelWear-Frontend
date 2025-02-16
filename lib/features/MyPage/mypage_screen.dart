import 'package:flutter/cupertino.dart';

class MyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("마이페이지"),
        automaticallyImplyLeading: false,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              _buildProfileSection(),

              SizedBox(height: 40),

              _buildPhotoSection(),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 프로필 영역
  Widget _buildProfileSection() {
    return Container(
      width: 361,
      height: 131,
      child: Stack(
        children: [
          // 🔹 프로필 이미지
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 75,
              height: 75,
              decoration: ShapeDecoration(
                color: CupertinoColors.white,
                shape: OvalBorder(
                  side: BorderSide(width: 2, color: Color(0xFF97999B)),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Icon(CupertinoIcons.person, size: 40, color: CupertinoColors.systemGrey),
            ),
          ),

          // 🔹 닉네임
          Positioned(
            left: 98,
            top: 12,
            child: Text(
              '닉네임',
              style: TextStyle(
                color: CupertinoColors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.71,
              ),
            ),
          ),

          // 🔹 ID
          Positioned(
            left: 98,
            top: 36,
            child: Text(
              '토마토',
              style: TextStyle(
                color: Color(0xFF97999B),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.71,
              ),
            ),
          ),

          // 🔹 프로필 편집 버튼
          Positioned(
            left: 0,
            top: 98,
            child: Container(
              width: 361,
              height: 33,
              decoration: ShapeDecoration(
                color: Color(0xFF3617CE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Center(
                child: Text(
                  '프로필 편집하기',
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.71,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 사진 추가 섹션
  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          color: CupertinoColors.systemGrey4,
        ),
        SizedBox(height: 30),
        Center(
          child: Column(
            children: [
              Text("내 사진 없음", style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey)),
              SizedBox(height: 10),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey5,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(CupertinoIcons.add, size: 40, color: CupertinoColors.systemGrey),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}


