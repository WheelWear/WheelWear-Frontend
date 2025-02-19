import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'signup_view_model.dart';
import '../login/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupViewModel(),
      builder: (context, child) {
        return SignUpScreenContent();
      },
    );
  }
}

class SignUpScreenContent extends StatefulWidget {
  @override
  _SignUpScreenContentState createState() => _SignUpScreenContentState();
}

class _SignUpScreenContentState extends State<SignUpScreenContent> {
  bool _agreeToTerms = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  void _showDialog(String message, {VoidCallback? onConfirm}) {
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
                if (onConfirm != null) onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSignUp() async {
    final signupViewModel = Provider.of<SignupViewModel>(context, listen: false);

    bool success = await signupViewModel.signUp(
      _idController.text,
      _passwordController.text,
      _passwordConfirmController.text,
      _nameController.text,
    );

    if (success) {
      _showDialog("회원가입 성공! 🚀", onConfirm: () {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => LoginScreen()),
        );
      });
    } else {
      _showDialog(signupViewModel.errorMessage ?? "회원가입 실패!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final signupViewModel = Provider.of<SignupViewModel>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("회원가입", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
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
            crossAxisAlignment: CrossAxisAlignment.stretch, // ✅ 버튼과 입력 필드가 꽉 차도록 설정
            children: [
              SizedBox(height: 80),
              _buildInputField("이름", "홍길동", _nameController),
              SizedBox(height: 15),
              _buildInputField("ID", "example@gmail.com", _idController),
              SizedBox(height: 15),
              _buildInputField("비밀번호", "must be 8 characters", _passwordController, obscureText: true),
              SizedBox(height: 15),
              _buildInputField("비밀번호 확인", "repeat password", _passwordConfirmController, obscureText: true),
              SizedBox(height: 15),

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
                  Text("약관 및 정책에 동의합니다."),
                ],
              ),
              SizedBox(height: 20),

              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CupertinoButton(
                  color: CupertinoColors.black,
                  borderRadius: BorderRadius.circular(10),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: signupViewModel.isLoading
                      ? CupertinoActivityIndicator()
                      : Text("회원가입", style: TextStyle(fontSize: 16, color: CupertinoColors.white)),
                  onPressed: _agreeToTerms ? _handleSignUp : null,
                ),
              ),
              SizedBox(height: 20),

          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text.rich(
                TextSpan(
                  text: "이미 회원가입을 하셨나요? ",
                  children: [
                    TextSpan(
                      text: "Log in",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.black,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),],
          ),
        ),
      ),
    );
  }


  Widget _buildInputField(String label, String placeholder, TextEditingController controller, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        SizedBox(height: 6),
        CupertinoTextField(
          controller: controller,
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
