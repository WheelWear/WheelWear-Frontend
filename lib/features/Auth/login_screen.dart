import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheelwear_frontend/features/Auth/signup/signup_screen.dart';
import '../../home_screen.dart';
import 'login/login_form_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../utils/token_storage.dart';

class LoginScreen extends StatelessWidget {
  final String? baseUrl = dotenv.env['BACKEND_URL'];

  Future<Map<String, dynamic>> _kakaoLogin(BuildContext context) async {
    final loginUrl = Uri.parse('$baseUrl/api/accounts/token/');
    try {
      final response = await http.post(
        loginUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": "admin",
          "password": "adminadmin",
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String? accessToken = responseData['access'];
        String? refreshToken = responseData['refresh'];
        bool isFirstLogin = responseData['is_first_login'] ?? false;

        if (accessToken != null && refreshToken != null) {
          await TokenStorage.saveAccessToken(accessToken);
          await TokenStorage.saveRefreshToken(refreshToken);
          print("🟢 토큰 저장 완료!");

          // 성공 결과 반환
          return {"success": true, "is_first_login": isFirstLogin};
        } else {
          print("🔴 로그인 성공했지만 토큰 없음.");
          return {"success": false};
        }
      }

      print("🔴 로그인 실패: ${response.statusCode}");
      return {"success": false};
    } catch (e) {
      _showError(context, '오류 발생: $e');
      return {"success": false};
    }
  }

  void _showError(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text('오류'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: Text('확인'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
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
              SizedBox(height: 130),
              // 인사말 텍스트
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
              // 서비스 로고
              Image.asset(
                "assets/auth/MainLogo.png",
                width: 270,
                height: 270,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 55),
              // 버튼 그룹
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 로그인 버튼
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
                    // 회원가입 버튼
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
                    // 카카오 로그인 버튼 (여기서 백엔드 로그인 진행)
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
                      onPressed: () async {
                        // 로그인 성공 여부에 따라 추가 로직 구현 가능
                        final result = await _kakaoLogin(context);
                        if (result['success'] == true) {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(builder: (context) => HomeScreen()),
                          );
                        }
                      },
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
