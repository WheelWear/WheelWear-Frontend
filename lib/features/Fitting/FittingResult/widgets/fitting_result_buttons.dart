import 'package:flutter/material.dart';

class FittingResultButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildButton(Icons.arrow_back, "처음으로", () {
            Navigator.pop(context); // ✅ 이전 화면으로 이동
          }),
          _buildMainButton(Icons.download, "코디에 저장", () {
            print("✅ 코디 저장 기능");
          }),
          _buildButton(Icons.swap_horiz, "상의 매칭하기", () {
            print("✅ 상의 매칭 기능");
          }),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 30),
          onPressed: onPressed,
        ),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildMainButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 8),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}
