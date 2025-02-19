import 'package:flutter/cupertino.dart';
//import 'package:image_picker/image_picker.dart';

class ProfileImageSection extends StatelessWidget{
  @override //상위클래스 메서드 재정의할때
  Widget build(BuildContext context){
    return Container(
      width: 75,
      height: 75,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: ShapeDecoration(
              color: CupertinoColors.white,
              shape: OvalBorder(
                side: BorderSide(width: 2, color: Color(0xFF97999B)),
              ),
              shadows: [
                BoxShadow(
                  color:Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0,4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipOval(
              child: Icon(
                CupertinoIcons.person,
                size: 40,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ),
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CupertinoColors.white,
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemGrey.withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                CupertinoIcons.pencil,
                size: 16,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class ProfileEditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("프로필 편집"),
        automaticallyImplyLeading: true,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              _buildProfileSection(context),
              SizedBox(height: 30),

              _buildInputField(label: "닉네임", placeholder: "토마토"),
              SizedBox(height: 20),

              _buildInputField(label: "ID", placeholder: "idididididid"),
              SizedBox(height: 20),

              _buildInputField(label: "비밀번호", placeholder: "password", obscureText: true), //비밀번호 암호화
              SizedBox(height: 20),
              // context 전달
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildInputField({required String label, required String placeholder, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        CupertinoTextField(
          placeholder: placeholder,
          obscureText: obscureText,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(10),
          ),
          suffix: Icon(CupertinoIcons.clear_circled, color: CupertinoColors.systemGrey),
        ),
      ],
    );
  }
}
Widget _buildProfileSection(BuildContext context) {
  return Row(
    children: [
      ProfileImageSection(), // 프로필 사진 위젯
      SizedBox(width: 16), // 간격 추가
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "토마토",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            "idididididid",
            style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
          ),
        ],
      ),
    ],
  );
}



