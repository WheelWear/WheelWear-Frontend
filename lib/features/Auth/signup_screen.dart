import 'package:flutter/cupertino.dart';

import 'login_screen.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _agreeToTerms = false;

  void _handleLogin() {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => LoginScreen()),
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
          child: Text("회원가입"),
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
            children: [
              SizedBox(height: 40),
              // SizedBox(height: 60),
              //
              // Text(
              //   "WheelWear 회원가입",
              //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              // ),

              SizedBox(height: 40),

              // ✅ 입력 필드 컨테이너
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField("닉네임", "name"),
                    SizedBox(height: 10),
                    _buildInputField("ID", "example@gmail.com"),
                    SizedBox(height: 10),
                    _buildInputField("비밀번호", "must be 8 characters", obscureText: true),
                    SizedBox(height: 10),
                    _buildInputField("비밀번호 확인", "repeat password", obscureText: true),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // ✅ 약관 동의 체크박스
              Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      _agreeToTerms ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.circle,
                      color: _agreeToTerms ? CupertinoColors.black : CupertinoColors.systemGrey,
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        _agreeToTerms = !_agreeToTerms;
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  Text("WheelWear 약관 및 정책에 동의합니다."),
                ],
              ),

              SizedBox(height: 20),

              // ✅ 회원가입 버튼
              CupertinoButton(
                color: CupertinoColors.black,
                borderRadius: BorderRadius.circular(10),
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Center(
                  child: Text("회원가입", style: TextStyle(fontSize: 16, color: CupertinoColors.white)),
                ),
                onPressed: _agreeToTerms ? () {
                  _handleLogin();
                } : null,
              ),

              SizedBox(height: 10),

              // ✅ 로그인 이동 링크
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text.rich(
                  TextSpan(
                    text: "이미 회원가입을 하셨나요? ",
                    children: [
                      TextSpan(
                        text: "Log in",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 입력 필드 공통 위젯
  Widget _buildInputField(String label, String placeholder, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        SizedBox(height: 6),
        CupertinoTextField(
          placeholder: placeholder,
          obscureText: obscureText,
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}
