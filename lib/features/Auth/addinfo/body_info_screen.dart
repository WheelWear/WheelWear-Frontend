import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'body_info_service.dart';
import '../../../home_screen.dart';

class BodyInfoScreen extends StatefulWidget {
  @override
  _BodyInfoScreenState createState() => _BodyInfoScreenState();
}

class _BodyInfoScreenState extends State<BodyInfoScreen> {
  final TextEditingController shoulderController = TextEditingController();
  final TextEditingController chestController = TextEditingController();
  final TextEditingController armController = TextEditingController();
  final TextEditingController waistController = TextEditingController();
  bool _isLoading = false;

  void _showDialog(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: Text("확인"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  // 🔹 체형 정보 제출 API 호출
  Future<void> _submitBodyInfo() async {
    if (shoulderController.text.isEmpty ||
        chestController.text.isEmpty ||
        armController.text.isEmpty ||
        waistController.text.isEmpty) {
      _showDialog("입력 오류", "모든 필드를 입력해 주세요.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final bodyInfoService = BodyInfoService();
    bool success = await bodyInfoService.submitBodyInfo(
      shoulderWidth: double.parse(shoulderController.text),
      chestCircumference: double.parse(chestController.text),
      armLength: double.parse(armController.text),
      waistCircumference: double.parse(waistController.text),
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      _showDialog("성공", "체형 정보가 저장되었습니다!");
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomeScreen())); // ✅ 홈으로 이동
    } else {
      _showDialog("오류", "체형 정보를 저장하는데 실패했습니다. 다시 시도해주세요.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("체형정보 입력", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
        trailing: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text("건너뛰기", style: TextStyle(color: CupertinoColors.inactiveGray, fontSize: 16)),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "더 정확한 사이즈 추천을 위해 체형정보를 입력해주세요!\n수정은 마이페이지에서 가능해요",
                style: TextStyle(fontSize: 14, color: CupertinoColors.inactiveGray),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),

              // ✅ 입력 필드 컨테이너
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField("어깨 너비", "어깨 너비를 입력해주세요(cm)", shoulderController),
                    SizedBox(height: 12),
                    _buildInputField("가슴 둘레", "가슴 둘레를 입력해주세요(cm)", chestController),
                    SizedBox(height: 12),
                    _buildInputField("팔 길이", "팔 길이를 입력해주세요(cm)", armController),
                    SizedBox(height: 12),
                    _buildInputField("허리 둘레", "허리 둘레를 입력해주세요(cm)", waistController),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // ✅ 확인 버튼
              Container(
                width: 300, // 원하는 버튼 너비
                child: CupertinoButton(
                  color: CupertinoColors.black,
                  borderRadius: BorderRadius.circular(10),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: _isLoading
                      ? CupertinoActivityIndicator() // ✅ 로딩 중이면 인디케이터 표시
                      : Text("확인", style: TextStyle(fontSize: 16, color: CupertinoColors.white, fontWeight: FontWeight.w500)),
                  onPressed: _isLoading ? null : _submitBodyInfo,
                ),
              ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 입력 필드 공통 위젯
  Widget _buildInputField(String label, String placeholder, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        SizedBox(height: 6),
        CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(8),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
