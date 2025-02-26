import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'profile_edit_screen.dart';
import 'package:wheelwear_frontend/features/Auth/addinfo/body_info_screen.dart';
import 'package:wheelwear_frontend/utils/navigation_button.dart';
import 'profile_provider.dart';
import 'profile_image_section.dart';
import 'package:provider/provider.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        // 데이터 로딩 중이면 로딩 인디케이터를 표시
        if (profileProvider.isLoading) {
          return Container(
            width: 361,
            height: 180,
            alignment: Alignment.center,
            child: CupertinoActivityIndicator(),
          );
        }

        return Container(
          width: 361,
          height: 180,
          child: Stack(
            children: [
              // 프로필 사진
              Positioned(
                left: 0,
                top: 0,
                child: ProfileImageSection(
                  imageUrl: profileProvider.profilePicture,
                  imageFile: profileProvider.profileImageFile, // provider에서 가져옴
                  onImageTap: null, // 여기서 null을 전달하여 수정 버튼을 숨김
                ),
              ),
              // 프로필 이름
              Positioned(
                left: 98,
                top: 12,
                child: Text(
                  profileProvider.name ?? '이름 없음',
                  style: TextStyle(
                    color: CupertinoColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.71,
                  ),
                ),
              ),
              // 전화번호
              Positioned(
                left: 98,
                top: 36,
                child: Text(
                  profileProvider.phoneNumber ?? '전화번호 없음',
                  style: TextStyle(
                    color: Color(0xFF97999B),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.71,
                  ),
                ),
              ),
              // 로그아웃 버튼
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
              // 프로필 편집하기 버튼
              Positioned(
                left: 0,
                top: 98,
                child: NavigationButton(
                  label: '프로필 편집하기',
                  targetPage: ProfileEditScreen(
                    profileProvider: Provider.of<ProfileProvider>(context, listen: false),
                  ),
                ),
              ),
              // 체형정보입력하기 버튼
              Positioned(
                left: 0,
                top: 141,
                child: NavigationButton(
                  label: '체형정보입력하기',
                  targetPage: BodyInfoScreen(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
