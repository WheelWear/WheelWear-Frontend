import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FittingResultButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildTextButton(CupertinoIcons.back, "처음으로", () {
                Navigator.pop(context);
              }),
            ),
          ),
          _buildMainButton(CupertinoIcons.arrow_down_circle_fill, "코디에 저장", () {
            print("✅ 코디 저장 기능");
          }),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: _buildTextButton(CupertinoIcons.arrow_right_arrow_left, "추가 피팅하기", () {
                print("✅ 상의 매칭 기능");
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextButton(IconData icon, String label, VoidCallback onPressed) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Icon(icon, size: 24, color: CupertinoColors.systemGrey),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey)),
        ],
      ),
    );
  }

  Widget _buildMainButton(IconData icon, String label, VoidCallback onPressed) {
    return CupertinoButton.filled(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      borderRadius: BorderRadius.circular(30),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: CupertinoColors.white, size: 18),
          SizedBox(width: 8),
          Text(label, style: TextStyle(color: CupertinoColors.white, fontSize: 16)),
        ],
      ),
    );
  }
}
