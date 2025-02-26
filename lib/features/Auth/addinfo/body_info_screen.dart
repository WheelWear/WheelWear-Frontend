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
  bool _isLoadingData = true; // 초기 데이터 로딩 상태
  bool _isSubmitting = false; // 제출 중 상태
  String _selectedGender = "M";

  @override
  void initState() {
    super.initState();
    _fetchBodyInfo();
  }

  // 백엔드에서 체형 정보를 가져오는 함수
  Future<void> _fetchBodyInfo() async {
    final bodyInfoService = BodyInfoService();
    final bodyInfo = await bodyInfoService.fetchBodyInfo();
    debugPrint("체형 정보: $bodyInfo");
    if (bodyInfo != null) {
      // 받아온 데이터를 각 컨트롤러에 할당
      shoulderController.text = bodyInfo['shoulder_width']?.toString() ?? "";
      chestController.text = bodyInfo['chest_circumference']?.toString() ?? "";
      armController.text = bodyInfo['arm_length']?.toString() ?? "";
      waistController.text = bodyInfo['waist_circumference']?.toString() ?? "";
      _selectedGender = bodyInfo['gender'] ?? "M";
    }
    setState(() {
      _isLoadingData = false;
    });
  }

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
      _isSubmitting = true;
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
      _isSubmitting = false;
    });

    if (success) {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomeScreen()));
    } else {
      _showDialog("오류", "체형 정보를 저장하는데 실패했습니다. 다시 시도해주세요.");
    }
  }

  // "건너뛰기" 버튼 클릭 시 홈 화면으로 이동
  void _skipToHome() {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 데이터를 불러오는 동안 로딩 화면 표시
    if (_isLoadingData) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("체형정보 입력"),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("체형정보 입력", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
        trailing: GestureDetector(
          onTap: _skipToHome,
          child: Text("건너뛰기", style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 16)),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20, // 키보드 높이만큼의 추가 패딩
            top: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "더 정확한 사이즈 추천을 위해 체형정보를 입력해주세요!\n수정은 마이페이지에서 가능해요",
                style: TextStyle(fontSize: 14, color: CupertinoColors.inactiveGray),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              _buildGenderSelector(),
              SizedBox(height: 20),
              _buildInputField("어깨 너비", "어깨 너비를 입력해주세요(cm)", shoulderController),
              SizedBox(height: 12),
              _buildInputField("가슴 둘레", "가슴 둘레를 입력해주세요(cm)", chestController),
              SizedBox(height: 12),
              _buildInputField("팔 길이", "팔 길이를 입력해주세요(cm)", armController),
              SizedBox(height: 12),
              _buildInputField("허리 둘레", "허리 둘레를 입력해주세요(cm)", waistController),
              SizedBox(height: 30),
              Container(
                width: 300,
                alignment: Alignment.center,
                child: CupertinoButton(
                  color: CupertinoColors.black,
                  borderRadius: BorderRadius.circular(10),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 150),
                  child: _isSubmitting
                      ? CupertinoActivityIndicator()
                      : Text("확인", style: TextStyle(fontSize: 16, color: CupertinoColors.white, fontWeight: FontWeight.w500)),
                  onPressed: _isSubmitting ? null : _submitBodyInfo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
