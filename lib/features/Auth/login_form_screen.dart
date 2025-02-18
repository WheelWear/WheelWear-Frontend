import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheelwear_frontend/home_screen.dart';

class LoginFormScreen extends StatefulWidget {
  @override
  _LoginFormScreenState createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  void _handleLogin() {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: DefaultTextStyle(
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: CupertinoColors.black,
          ),
          child: Text("로그인"),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30),

              // // ✅ 로그인 타이틀
              // Text(
              //   "로그인",
              //   style: TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //     color: CupertinoColors.black,
              //   ),
              // ),

              // SizedBox(height: 20),

              // ✅ 서비스 로고
              Image.asset(
                "assets/auth/MainLogo.png", // 경로 확인 필요
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),

              SizedBox(height: 40),

              // ✅ ID 입력 필드
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  SizedBox(height: 6),
                  CupertinoTextField(
                    placeholder: "Your email",
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // ✅ Password 입력 필드
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Password", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  SizedBox(height: 6),
                  CupertinoTextField(
                    placeholder: "Your password",
                    obscureText: true,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 70),

              // ✅ 로그인 버튼
              CupertinoButton(
                color: CupertinoColors.black,
                borderRadius: BorderRadius.circular(10),
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text("Log in", style: TextStyle(fontSize: 16, color: CupertinoColors.white)),
                ),
                onPressed: _handleLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
