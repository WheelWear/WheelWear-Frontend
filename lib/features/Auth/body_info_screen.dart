import 'package:flutter/cupertino.dart';

class BodyInfoScreen extends StatefulWidget {
  @override
  _BodyInfoScreenState createState() => _BodyInfoScreenState();
}

class _BodyInfoScreenState extends State<BodyInfoScreen> {
  String gender = '';
  final TextEditingController shoulderController = TextEditingController();
  final TextEditingController chestController = TextEditingController();
  final TextEditingController armController = TextEditingController();
  final TextEditingController waistController = TextEditingController();

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
          child: Text("체형정보 입력"),
        ),
        trailing: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            "건너뛰기",
            style: TextStyle(
              color: CupertinoColors.inactiveGray,
              fontSize: 16,
            ),
          ),
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
                style: TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.inactiveGray,
                ),
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
                    _buildGenderSelector(),
                    SizedBox(height: 20),
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
                  child: Center(
                    child: Text(
                      "확인",
                      style: TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onPressed: _submitBodyInfo,
                ),
              ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 성별 선택 위젯
  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("성별", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        Row(
          children: [
            _buildGenderButton("남성"),
            SizedBox(width: 16),
            _buildGenderButton("여성"),
          ],
        ),
      ],
    );
  }

  // 🔹 성별 버튼
  Widget _buildGenderButton(String label) {
    bool isSelected = gender == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          gender = label;
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
            style: TextStyle(fontSize: 16, color: CupertinoColors.black),
          ),
        ],
      ),
    );
  }

  // 🔹 입력 필드 공통 위젯
  Widget _buildInputField(
      String label, String placeholder, TextEditingController controller,
      {bool obscureText = false}) {
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
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  // 🔹 정보 제출

  void _submitBodyInfo() {
    if (gender.isEmpty ||
        shoulderController.text.isEmpty ||
        chestController.text.isEmpty ||
        armController.text.isEmpty ||
        waistController.text.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text("입력 오류"),
          content: Text("모든 필드를 입력해 주세요."),
          actions: [
            CupertinoDialogAction(
              child: Text("확인"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }
    Navigator.pop(context);
  }
}
