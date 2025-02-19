import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../home_screen.dart';
import 'login_form_service.dart';

class LoginFormScreen extends StatefulWidget {
  @override
  _LoginFormScreenState createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _showDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("알림"),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final loginService = LoginService();
    bool success = await loginService.login(_idController.text, _passwordController.text);

    setState(() {
      _isLoading = false;
    });

    if (!success) {
      _showDialog("로그인 실패!🥲");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("로그인", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
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

              Image.asset(
                "assets/auth/MainLogo.png",
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),

              SizedBox(height: 40),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  SizedBox(height: 6),
                  CupertinoTextField(
                    controller: _idController,
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

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Password", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  SizedBox(height: 6),
                  CupertinoTextField(
                    controller: _passwordController,
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

              Container(
                width: double.infinity,
                child: CupertinoButton(
                  color: CupertinoColors.black,
                  borderRadius: BorderRadius.circular(10),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: _isLoading
                      ? CupertinoActivityIndicator()
                      : Text("Log in", style: TextStyle(fontSize: 16, color: CupertinoColors.white)),
                  onPressed: _isLoading ? null : _handleLogin,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
