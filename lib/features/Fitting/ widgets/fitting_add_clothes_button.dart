import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FittingAddClothesButton extends StatelessWidget {
  final VoidCallback onToggleCloset;

  FittingAddClothesButton({required this.onToggleCloset});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggleCloset,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(
            color: CupertinoColors.systemGrey4,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            CupertinoIcons.add,
            size: 30,
            color: CupertinoColors.systemGrey4,
          ),
        ),
      ),
    );
  }
}
