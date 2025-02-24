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
  String _selectedGender = "M";

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

  Future<void> _submitBodyInfo() async {
    setState(() {
      _isLoading = true;
    });

    final bodyInfoService = BodyInfoService();
    bool success = await bodyInfoService.submitBodyInfo(
      shoulderWidth: double.tryParse(shoulderController.text),
      chestCircumference: double.tryParse(chestController.text),
      armLength: double.tryParse(armController.text),
      waistCircumference: double.tryParse(waistController.text),
      gender: _selectedGender,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomeScreen()));
    } else {
      _showDialog("오류", "체형 정보를 저장하는데 실패했습니다. 다시 시도해주세요.");
    }
  }

  // ✅ "건너뛰기" 버튼 클릭 시 홈 화면으로 이동
  void _skipToHome() {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("체형정보 입력", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
        trailing: GestureDetector(
          onTap: _skipToHome, // ✅ "건너뛰기" 버튼 클릭 시 홈 화면으로 이동
          child: Text("건너뛰기", style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 16)),
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

              // ✅ 성별 선택 UI (체크 아이콘 적용)
              _buildGenderSelector(),
              SizedBox(height: 20),

              // ✅ 체형 정보 입력 필드
              _buildInputField("어깨 너비", "어깨 너비를 입력해주세요(cm)", shoulderController),
              SizedBox(height: 12),
              _buildInputField("가슴 둘레", "가슴 둘레를 입력해주세요(cm)", chestController),
              SizedBox(height: 12),
              _buildInputField("팔 길이", "팔 길이를 입력해주세요(cm)", armController),
              SizedBox(height: 12),
              _buildInputField("허리 둘레", "허리 둘레를 입력해주세요(cm)", waistController),

              SizedBox(height: 30),

              // ✅ 확인 버튼
              Container(
                width: 300,
                child: CupertinoButton(
                  color: CupertinoColors.black,
                  borderRadius: BorderRadius.circular(10),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: _isLoading
                      ? CupertinoActivityIndicator()
                      : Text("확인", style: TextStyle(fontSize: 16, color: CupertinoColors.white, fontWeight: FontWeight.w500)),
                  onPressed: _isLoading ? null : _submitBodyInfo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 성별 선택 위젯 (체크 아이콘 적용)
  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("성별", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        Row(
          children: [
            _buildGenderButton("M", "남성"),
            SizedBox(width: 16),
            _buildGenderButton("F", "여성"),
          ],
        ),
      ],
    );
  }

  // 🔹 성별 버튼
  Widget _buildGenderButton(String value, String label) {
    bool isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Row(
        children: [
          Icon(
            isSelected ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.circle,
            color: isSelected ? CupertinoColors.black : CupertinoColors.systemGrey,
            size: 22,
          ),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.black,
            ),
          ),
        ],
      ),
    );
  }

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
