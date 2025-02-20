import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheelwear_frontend/features/Auth/signup/signup_screen.dart';
import '../../home_screen.dart';
import 'login/login_form_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 130),

              // ✅ 인사말 텍스트
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "나만의 피팅룸,",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 20, color: CupertinoColors.black),
                      children: [
                        TextSpan(
                          text: "Wheelwear",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: "을 시작해보세요!"),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              // ✅ 서비스 로고
              Image.asset(
                "assets/auth/MainLogo.png",
                width: 270,
                height: 270,
                fit: BoxFit.contain,
              ),

              SizedBox(height: 55),

              // ✅ 버튼 그룹
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ✅ 로그인 버튼
                    CupertinoButton(
                      color: CupertinoColors.black,
                      borderRadius: BorderRadius.circular(10),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text("로그인", style: TextStyle(fontSize: 14, color: CupertinoColors.white)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => LoginFormScreen()),
                        );
                      },
                    ),

                    SizedBox(height: 10),

                    // ✅ 회원가입 버튼
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: CupertinoColors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text("회원가입", style: TextStyle(fontSize: 14, color: CupertinoColors.black)),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                    ),

                    SizedBox(height: 10),

                    // ✅ 카카오 로그인 버튼
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFE812),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.chat_bubble_fill, color: Colors.black, size: 20),
                            SizedBox(width: 8),
                            Text("카카오 로그인", style: TextStyle(fontSize: 14, color: Colors.black)),
                          ],
                        ),
                      ),
                      onPressed: () { Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => HomeScreen()),
                      );},
                    ),
                  ],
                ),
              ),

              Spacer(),

              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
