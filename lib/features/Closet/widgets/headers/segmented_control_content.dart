import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/closet_item.dart';
import '../../providers/closet_filter_provider.dart';
import 'package:provider/provider.dart';

enum Sky { midnight, viridian, cerulean }

class SegmentedControlContent extends StatefulWidget {
  const SegmentedControlContent({super.key});

  @override
  State<SegmentedControlContent> createState() =>
      _SegmentedControlContentState();
}

class _SegmentedControlContentState extends State<SegmentedControlContent> {
  Sky _selectedSegment = Sky.midnight;

  // 선택된 텍스트 스타일과 선택되지 않은 텍스트 스타일 정의
  final TextStyle selectedStyle = const TextStyle(
    color: CupertinoColors.activeBlue, // 선택되었을 때의 색상 (예: 파란색)
    fontWeight: FontWeight.bold,
  );

  final TextStyle unselectedStyle = const TextStyle(
    color: CupertinoColors.black, // 선택되지 않았을 때의 색상
    fontWeight: FontWeight.bold,
  );

  // Sky -> ClosetCategory 매핑 함수
  ClosetCategory _mapSkyToClosetCategory(Sky sky) {
    switch (sky) {
      case Sky.midnight:
        return ClosetCategory.myClothes;     // '상의'
      case Sky.viridian:
        return ClosetCategory.wishlist;  // '하의'
      case Sky.cerulean:
        return ClosetCategory.donation;   // '원피스'
    }
  }

  @override
  Widget build(BuildContext context) {

    final segmentProvider = Provider.of<ClosetFilterProvider>(context);

    return CupertinoSlidingSegmentedControl<Sky>(
      backgroundColor: CupertinoColors.white,
      // thumbColor를 투명하게 처리하여 배경 변화가 보이지 않도록 함
      // thumbColor: Colors.transparent,
      // groupValue: _selectedSegment,
      onValueChanged: (Sky? value) {
        if (value != null) {
          setState(() {
            _selectedSegment = value;
          });
          // 글로벌 상태 변경: selectedClothType을 Sky.midnight로 고정
          segmentProvider.selectedClothType = ClothType.Top;
          context.read<ClosetFilterProvider>().updateClosetCategory(_mapSkyToClosetCategory(value));
        }
      },
      children: <Sky, Widget>{
        Sky.midnight: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '내 옷',
            style: _selectedSegment == Sky.midnight
                ? selectedStyle
                : unselectedStyle,
          ),
        ),
        Sky.viridian: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '위시리스트',
            style: _selectedSegment == Sky.viridian
                ? selectedStyle
                : unselectedStyle,
          ),
        ),
        Sky.cerulean: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '기부함',
            style: _selectedSegment == Sky.cerulean
                ? selectedStyle
                : unselectedStyle,
          ),
        ),
      },
    );
  }
}
