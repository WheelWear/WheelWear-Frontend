import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Sky { midnight, viridian, cerulean }

class CategoryTabs extends StatefulWidget {
  const CategoryTabs({super.key});

  @override
  State<CategoryTabs> createState() => CategoryTabsState();
}

class CategoryTabsState extends State<CategoryTabs> {
  Sky _selectedSegment = Sky.midnight;

  // 선택된 텍스트 스타일과 선택되지 않은 텍스트 스타일 정의
  final TextStyle selectedStyle = const TextStyle(
    color: CupertinoColors.activeGreen, // 선택되었을 때의 색상 (예: 파란색)
    fontWeight: FontWeight.bold,

  );

  final TextStyle unselectedStyle = const TextStyle(
    color: CupertinoColors.black, // 선택되지 않았을 때의 색상
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<Sky>(
      backgroundColor: CupertinoColors.white,
      onValueChanged: (Sky? value) {
        if (value != null) {
          setState(() {
            _selectedSegment = value;
          });
        }
      },
      children: <Sky, Widget>{
        Sky.midnight: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1), // 간격 줄임
          child: Text(
            '상의',
            style: _selectedSegment == Sky.midnight
                ? selectedStyle
                : unselectedStyle,
          ),
        ),
        Sky.viridian: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1), // 간격 줄임
          child: Text(
            '하의',
            style: _selectedSegment == Sky.viridian
                ? selectedStyle
                : unselectedStyle,
          ),
        ),
        Sky.cerulean: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1), // 간격 줄임
          child: Text(
            '원피스',
            style: _selectedSegment == Sky.cerulean
                ? selectedStyle
                : unselectedStyle,
          ),
        ),
      },
    );
  }
}
