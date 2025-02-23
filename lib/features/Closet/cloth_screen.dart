import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // 📌 (추가) 카메라 패키지 불러오기
import 'dart:io'; // 📌 (추가) 파일 처리를 위한 dart:io 추가

class ClothScreen extends StatefulWidget { // 🔄 (수정) StatelessWidget → StatefulWidget으로 변경 (이미지 업데이트 필요)
  @override
  _ClothScreenState createState() => _ClothScreenState();
}

class _ClothScreenState extends State<ClothScreen> { // 🔄 (추가) 이미지 상태 저장을 위한 StatefulWidget
  File? _selectedImage; // 📌 (추가) 선택된 이미지 저장 변수

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("옷장에 옷 넣기", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),

                // 🔹 이미지 영역 (📌 수정: 클릭 시 카메라 실행)
                GestureDetector( // 📌 (추가) 클릭 이벤트 추가
                  onTap: () async { // 📌 (추가) 카메라 화면으로 이동하는 기능 추가
                    final imagePath = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CameraScreen()),
                    );
                    if (imagePath != null) { // 📌 (추가) 촬영한 이미지가 있으면 업데이트
                      setState(() {
                        _selectedImage = File(imagePath);
                      });
                    }
                  },
                  child: Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey4,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: _selectedImage == null // 🔄 (수정) 이미지가 있으면 표시, 없으면 텍스트 표시
                        ? Center(
                      child: Text(
                        "사진을 추가해주세요!",
                        style: TextStyle(color: CupertinoColors.white, fontSize: 18),
                      ),
                    )
                        : Image.file(_selectedImage!, fit: BoxFit.cover), // 📌 (추가) 촬영한 이미지 표시
                  ),
                ),

                SizedBox(height: 10),
                Text(
                  "올바른 카테고리를 선택해주세요.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),

                SizedBox(height: 5),

                // 🔹 "내 옷", "위시리스트" 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomBorderButton(label: "내 옷"),
                    SizedBox(width: 15),
                    CustomBorderButton(label: "위시리스트"),
                  ],
                ),

                SizedBox(height: 5),

                Text(
                  "올바른 카테고리를 선택해주세요.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),

                SizedBox(height: 5),

                // 🔹 "상의", "하의", "원피스" 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomBorderButton(label: "상의"),
                    SizedBox(width: 15),
                    CustomBorderButton(label: "하의"),
                    SizedBox(width: 15),
                    CustomBorderButton(label: "원피스"),
                  ],
                ),

                SizedBox(height: 5),

                // 🔹 "브랜드 입력(선택)" 왼쪽 & 사이즈 추천 문구 오른쪽
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "브랜드 입력(선택)",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      "입력하신 체형정보에 맞는 사이즈를 추천해드려요",
                      style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                      textAlign: TextAlign.right, // 오른쪽 정렬
                    ),
                  ],
                ),

                SizedBox(height: 5),

                // 🔹 브랜드 입력 칸
                CupertinoTextField(
                  placeholder: "브랜드를 입력하세요",
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                SizedBox(height: 15),

                // 🔹 완료 버튼 (검은색 배경)
                CustomBorderButton(
                  label: "완료",
                  isFullWidth: true,
                  isBlackButton: true,
                  onTap: () {
                    print("완료 버튼 클릭!");
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 📌 (추가) 카메라 화면 추가
class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera(); // 📌 (추가) 카메라 초기화 실행
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _controller = CameraController(_cameras![0], ResolutionPreset.high);
      await _controller!.initialize();
      setState(() => _isCameraInitialized = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("카메라")),
      body: _isCameraInitialized
          ? CameraPreview(_controller!) // 📌 (추가) 카메라 화면 미리보기
          : Center(child: CircularProgressIndicator()), // 📌 (추가) 카메라 로딩 중

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_controller != null) {
            XFile file = await _controller!.takePicture();
            Navigator.pop(context, file.path); // 📌 (추가) 촬영한 사진 경로 반환
          }
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}

class CustomBorderButton extends StatefulWidget {
  final String label;
  final bool isFullWidth;
  final bool isBlackButton;
  final VoidCallback? onTap;

  const CustomBorderButton({
    Key? key,
    required this.label,
    this.isFullWidth = false,
    this.isBlackButton = false,
    this.onTap,
  }) : super(key: key);

  @override
  _CustomBorderButtonState createState() => _CustomBorderButtonState();
}

class _CustomBorderButtonState extends State<CustomBorderButton> {
  bool _isToggled = false; // 버튼 상태 토글

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _isToggled = !_isToggled); // 버튼 눌릴 때마다 상태 변경
        if (widget.onTap != null) widget.onTap!();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: widget.isFullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: widget.isBlackButton
              ? (_isToggled ? CupertinoColors.systemGrey : CupertinoColors.black) // 완료 버튼 (토글)
              : (_isToggled ? CupertinoColors.systemGrey2 : CupertinoColors.white), // 일반 버튼 (토글)
          border: Border.all(color: CupertinoColors.black, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.isBlackButton ? CupertinoColors.white : CupertinoColors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}