import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheelwear_frontend/home_screen.dart';

class LoginFormScreen extends StatefulWidget {
  @override
  _LoginFormScreenState createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  void _handleLogin() {
    // ✅ 로그인 버튼 클릭 시 홈 화면으로 이동
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),

              // ✅ 로그인 타이틀
              Text(
                "로그인",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.black,
                ),
              ),

              SizedBox(height: 20),

              // ✅ 서비스 로고
              Image.asset(
                "assets/auth/splashLogo.png", // 경로 확인 필요
                width: 120,
                height: 120,
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

              SizedBox(height: 30),

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
