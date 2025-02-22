import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/closet_item.dart';
import '../../providers/closet_filter_provider.dart';

enum Sky { midnight, viridian, cerulean }

class CategoryTabs extends StatelessWidget {
  const CategoryTabs({super.key});

  // ClothType -> Sky 매핑 함수 추가
  Sky _mapClothTypeToSky(ClothType type) {
    switch (type) {
      case ClothType.Top:
        return Sky.midnight;    // '상의'
      case ClothType.Bottom:
        return Sky.viridian;    // '하의'
      case ClothType.Dress:
        return Sky.cerulean;    // '원피스'
      default:
        return Sky.midnight;
    }
  }

  // Sky -> ClothType 매핑 함수
  ClothType _mapSkyToClothType(Sky sky) {
    switch (sky) {
      case Sky.midnight:
        return ClothType.Top;
      case Sky.viridian:
        return ClothType.Bottom;
      case Sky.cerulean:
        return ClothType.Dress;
    }
  }

  // 선택된 텍스트 스타일과 선택되지 않은 텍스트 스타일 정의
  final TextStyle selectedStyle = const TextStyle(
    color: CupertinoColors.activeGreen,
    fontWeight: FontWeight.bold,
  );

  final TextStyle unselectedStyle = const TextStyle(
    color: CupertinoColors.black,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<ClosetFilterProvider>(
      builder: (context, provider, child) {
        // 프로바이더의 현재 cloth_type 상태를 Sky로 변환하여 사용
        final selectedSegment = _mapClothTypeToSky(provider.selectedClothType);

        return CupertinoSlidingSegmentedControl<Sky>(
          backgroundColor: CupertinoColors.white,
          onValueChanged: (Sky? value) {
            if (value != null) {
              // 선택 값이 변경되면 프로바이더의 cloth_type 업데이트
              provider.updateClothType(_mapSkyToClothType(value));
            }
          },
          children: {
            Sky.midnight: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Text(
                '상의',
                style: selectedSegment == Sky.midnight ? selectedStyle : unselectedStyle,
              ),
            ),
            Sky.viridian: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Text(
                '하의',
                style: selectedSegment == Sky.viridian ? selectedStyle : unselectedStyle,
              ),
            ),
            Sky.cerulean: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Text(
                '원피스',
                style: selectedSegment == Sky.cerulean ? selectedStyle : unselectedStyle,
              ),
            ),
          },
        );
      },
    );
  }
}