import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_edit_screen.dart';
import '../../utils/body_image_provider.dart';

class MyPageScreen extends StatefulWidget {
  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class AlarmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Align(
          alignment: Alignment.center,
          child: Text(
            "알림",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 0,
          child: Icon(
            CupertinoIcons.clear,
            size: 30,
            color: CupertinoColors.systemGrey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      child: SafeArea(
        child: Container(
          color: CupertinoColors.systemGrey6,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "오늘 받은 알림",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              _buildNotificationCard(
                  "👕", "띠링~ 기부하실 시간!", "기부함이 다 찼어요. 방문수거 서비스를 신청해주세요.", "8h"),
              SizedBox(height: 20),
              Text(
                "이전 알림",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              _buildNotificationCard(
                  "🎉", "첫 기부 축하드립니다!", "방문수거 서비스는 어땠는지 평가해주세요.", "1yr"),
              _buildNotificationCard(
                  "🚀",
                  "입지 않는 옷을 기부해보는 건 어떠세요?",
                  "내 옷장에서 기부함에 넣으면, 저희 WheelWear가 수거해 가요!",
                  "1yr"),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildNotificationCard(
    String emoji, String title, String content, String time) {
  return Container(
    padding: EdgeInsets.all(12),
    margin: EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: CupertinoColors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: CupertinoColors.black.withOpacity(0.05),
          blurRadius: 10,
          spreadRadius: 2,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: TextStyle(fontSize: 24)),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                        fontSize: 12, color: CupertinoColors.systemGrey),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(content,
                  style: TextStyle(fontSize: 14, color: CupertinoColors.black)),
            ],
          ),
        ),
      ],
    ),
  );
}

class _MyPageScreenState extends State<MyPageScreen> {
  // _selectedImage와 _pickImage()는 더 이상 사용하지 않고,
  // BodyImageProvider에서 관리하는 bodyImageUrl를 활용합니다.

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("마이페이지"),
        automaticallyImplyLeading: false,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero, // 버튼 기본 패딩 제거
          minSize: 0, // 사이즈 작아서 안보이는거 방지
          child: Icon(
            CupertinoIcons.bell,
            size: 30,
            color: CupertinoColors.systemGrey,
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => AlarmScreen()),
            );
          }, // 알림 아이콘
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildProfileSection(context),
              SizedBox(height: 40),
              _buildPhotoSection(),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 프로필 영역 (변경 없음)
  Widget _buildProfileSection(BuildContext context) {
    return Container(
      width: 361,
      height: 131,
      child: Stack(
        children: [
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
              child: Icon(CupertinoIcons.person,
                  size: 40, color: CupertinoColors.systemGrey),
            ),
          ),
          Positioned(
            left: 98,
            top: 12,
            child: Text(
              '토마토',
              style: TextStyle(
                color: CupertinoColors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.71,
              ),
            ),
          ),
          Positioned(
            left: 98,
            top: 36,
            child: Text(
              'tomato123',
              style: TextStyle(
                color: Color(0xFF97999B),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.71,
              ),
            ),
          ),
          Positioned(
            left: 200,
            top: 34,
            child: CupertinoButton(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              minSize: 0,
              borderRadius: BorderRadius.circular(8),
              color: CupertinoColors.systemGrey6,
              child: Text(
                "로그아웃",
                style: TextStyle(
                  color: CupertinoColors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                print("로그아웃되었습니다");
              },
            ),
          ),
          Positioned(
            left: 0,
            top: 98,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ProfileEditScreen(),
                  ),
                );
              },
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
          ),
        ],
      ),
    );
  }

// 🔹 사진 추가/변경 섹션 (Provider 사용)
  Widget _buildPhotoSection() {
    return Consumer<BodyImageProvider>(
      builder: (context, bodyImageProvider, child) {
        final imageUrl = bodyImageProvider.bodyImageUrl;
        final isUploading = bodyImageProvider.isUploading;

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
                  if (imageUrl == null) ...[
                    Text(
                      "내 사진 없음",
                      style: TextStyle(
                          fontSize: 14, color: CupertinoColors.systemGrey),
                    ),
                    SizedBox(height: 10),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Container(
                        width: 80,
                        height: 80,
                        child: Icon(
                          CupertinoIcons.add,
                          size: 120,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      onPressed: isUploading
                          ? null
                          : () async {
                        await bodyImageProvider.pickAndUploadMyPageBodyImage();
                      },
                    ),
                  ] else
                    ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageUrl,
                          width: 310,
                          height: 410,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 310,
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: isUploading
                              ? null
                              : () async {
                            await bodyImageProvider
                                .pickAndUploadMyPageBodyImage();
                          },
                          child: Container(
                            width: 90,
                            height: 28,
                            decoration: ShapeDecoration(
                              color: isUploading ? Color(0xFFA0A0A0) : Color(
                                  0xFFC3C3C3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            child: Center(
                              child: isUploading
                                  ? CupertinoActivityIndicator()
                                  : Text(
                                "사진 변경",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: CupertinoColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}