import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:wheelwear_frontend/utils/CameraScreenWithOverlay.dart'; // 분리한 카메라 모듈 import
import './services/api_service.dart';
import './providers/closet_items_provider.dart';
// 에러 메시지 표시를 위한 CupertinoAlertDialog 사용

Future<void> uploadClothSubmit(
    XFile selectedImage,
    String closetType,
    String size,
    String brand,
    String closetCategory,
    ) async {
  ApiService uploadService = ApiService();
  File imageFile = File(selectedImage.path);
  await uploadService.uploadClothItems(
      imageFile, closetType, size, brand, closetCategory);
}

class AddClothScreen extends StatefulWidget {
  final ClosetItemsProvider closetItemsProvider;

  const AddClothScreen({Key? key, required this.closetItemsProvider})
      : super(key: key);

  @override
  _AddClothScreenState createState() => _AddClothScreenState();
}

class _AddClothScreenState extends State<AddClothScreen> {
  XFile? _selectedImage;
  String? _selectedCategory; // "내 옷" 또는 "위시리스트"
  String? _selectedType; // "상의", "하의", "원피스"

  final TextEditingController _size = TextEditingController();
  final TextEditingController _brand = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  // 이미지 선택 함수: CupertinoActionSheet 사용
  Future<void> _pickImage() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text("이미지 선택"),
        actions: [
          CupertinoActionSheetAction(
            child: Row(
              children: [
                Icon(CupertinoIcons.camera),
                SizedBox(width: 8),
                Text("카메라"),
              ],
            ),
            onPressed: () async {
              Navigator.pop(context);
              // 커스텀 카메라 위젯 호출 (분리한 모듈 사용)
              final imagePath = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraScreenWithOverlay(
                    guidelineAsset: 'assets/closet/top_cloth_guideline_s.png',
                  ),
                ),
              );
              if (imagePath != null) {
                setState(() {
                  _selectedImage = XFile(imagePath);
                });
              }
            },
          ),
          CupertinoActionSheetAction(
            child: Row(
              children: [
                Icon(CupertinoIcons.photo),
                SizedBox(width: 8),
                Text("앨범"),
              ],
            ),
            onPressed: () async {
              Navigator.pop(context);
              final XFile? image =
              await _picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                setState(() {
                  _selectedImage = image;
                });
              }
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("취소"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  // 선택 버튼 UI: CupertinoButton 스타일과 Material Container 조합
  Widget _buildSelectButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.white,
          border: Border.all(color: CupertinoColors.systemGrey2, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.black : Colors.grey[800]),
        ),
      ),
    );
  }

  // 완료 버튼 UI: CupertinoButton.filled 활용
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton.filled(
        padding: EdgeInsets.symmetric(vertical: 14),
        onPressed: () async {
          if (_selectedImage == null ||
              _selectedType == null ||
              _selectedCategory == null) {
            // 필수 선택 항목 미선택 시 CupertinoAlertDialog 사용
            await showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: Text("오류"),
                content: Text("필수 항목을 모두 선택해주세요."),
                actions: [
                  CupertinoDialogAction(
                    child: Text("확인"),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            );
            return;
          }

          try {
            await uploadClothSubmit(
              _selectedImage!,
              _selectedType!,
              _size.text,
              _brand.text,
              _selectedCategory!,
            );
            await widget.closetItemsProvider.fetchClosetItems();
            Navigator.of(context).pop();
          } catch (error) {
            await showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: Text("업로드 실패"),
                content: Text(error.toString()),
                actions: [
                  CupertinoDialogAction(
                    child: Text("확인"),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            );
          }
        },
        child: Text(
          "완료",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // CupertinoPageScaffold와 Material Scaffold의 혼합 사용
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("옷장에 옷 넣기"),
      ),
      child: SafeArea(
        child: Material(
          color: Colors.white,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                // 이미지 선택 영역
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: _selectedImage == null
                        ? Center(
                      child: Text(
                        "사진을 추가해주세요!",
                        style:
                        TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        File(_selectedImage!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "올바른 카테고리를 선택해주세요.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5),
                // "내 옷" / "위시리스트" 배타적 선택
                Row(
                  children: [
                    _buildSelectButton(
                      label: "내 옷",
                      isSelected: _selectedCategory == "myClothes",
                      onTap: () =>
                          setState(() => _selectedCategory = "myClothes"),
                    ),
                    SizedBox(width: 15),
                    _buildSelectButton(
                      label: "위시리스트",
                      isSelected: _selectedCategory == "wishlist",
                      onTap: () =>
                          setState(() => _selectedCategory = "wishlist"),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "어떤 종류의 옷인가요?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5),
                // "상의" / "하의" / "원피스" 배타적 선택
                Row(
                  children: [
                    _buildSelectButton(
                      label: "상의",
                      isSelected: _selectedType == "Top",
                      onTap: () => setState(() => _selectedType = "Top"),
                    ),
                    SizedBox(width: 15),
                    _buildSelectButton(
                      label: "하의",
                      isSelected: _selectedType == "Bottom",
                      onTap: () => setState(() => _selectedType = "Bottom"),
                    ),
                    SizedBox(width: 15),
                    _buildSelectButton(
                      label: "원피스",
                      isSelected: _selectedType == "Dress",
                      onTap: () => setState(() => _selectedType = "Dress"),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                // 사이즈 입력
                Text(
                  "사이즈 입력 (선택)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: _size,
                  decoration: InputDecoration(
                    hintText: "사이즈를 입력하세요",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 5),
                // 브랜드 입력 및 사이즈 추천 문구
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "브랜드 입력 (선택)",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      "입력하신 체형정보에 맞는 사이즈를 추천해드려요",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                TextField(
                  controller: _brand,
                  decoration: InputDecoration(
                    hintText: "브랜드를 입력하세요",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 15),
                _buildSubmitButton(),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
