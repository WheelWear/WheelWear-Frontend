import 'package:flutter/material.dart';

class AddClothButton extends StatelessWidget {
  const AddClothButton({Key? key}) : super(key: key);

  void _onTap(BuildContext context) {
    // 옷 추가 버튼 onTap 로직 (예시: 스낵바 노출)
    debugPrint('Add Cloth Button Tapped');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 3.0, // 보더 굵기 설정
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(Icons.add, color: Colors.grey, size: 40),
        ),
      ),
    );
  }
}