import 'package:flutter/material.dart';
import '../../add_cloth_screen.dart'; // 새로운 페이지 import

class AddClothButton extends StatelessWidget {
  const AddClothButton({Key? key}) : super(key: key);

  void _onTap(BuildContext context) {
    // 옷 추가 버튼 onTap 시 AddClothPage로 이동
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddClothScreen()),
    );
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
