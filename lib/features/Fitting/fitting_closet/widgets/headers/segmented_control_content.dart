import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/closet_item.dart';
import '../../providers/closet_filter_provider.dart';

enum Sky { midnight, viridian }

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
        return ClosetCategory.myClothes;
      case Sky.viridian:
        return ClosetCategory.wishlist;
    }
  }

  @override
  Widget build(BuildContext context) {

    final segmentProvider = Provider.of<ClosetFilterProvider>(context);

    return CupertinoSlidingSegmentedControl<Sky>(
      backgroundColor: CupertinoColors.white,
      onValueChanged: (Sky? value) {
        if (value != null) {
          setState(() {
            _selectedSegment = value;
          });
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
      },
    );
  }
}
