import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/closet_item.dart';
import '../../providers/closet_filter_provider.dart';

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
        return ClosetCategory.myClothes; // '상의'
      case Sky.viridian:
        return ClosetCategory.wishlist; // '하의'
      case Sky.cerulean:
        return ClosetCategory.donation; // '원피스'
    }
  }

  @override
  Widget build(BuildContext context) {
    final segmentProvider = Provider.of<ClosetFilterProvider>(context);
    final int donationCount = 3; // 예시로 0을 사용

    return CupertinoSlidingSegmentedControl<Sky>(
      backgroundColor: CupertinoColors.white,
      onValueChanged: (Sky? value) {
        if (value != null) {
          setState(() {
            _selectedSegment = value;
          });
          // 글로벌 상태 변경 예시 (원하는 대로 수정)
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '기부함',
                style: _selectedSegment == Sky.cerulean
                    ? selectedStyle
                    : unselectedStyle,
              ),
              const SizedBox(width: 4),
              // 아이콘 대신 간단한 배지로 표시 (디자인은 원하는대로 수정)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: CupertinoColors.activeBlue, // 배경색
                  borderRadius: BorderRadius.circular(12), // 둥근 모서리
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGrey.withOpacity(0.5),
                      offset: const Offset(0, 1),
                      blurRadius: 3,
                    )
                  ],
                ),
                child: Text(
                  '$donationCount',
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )

            ],
          ),
        ),
      },
    );
  }
}
