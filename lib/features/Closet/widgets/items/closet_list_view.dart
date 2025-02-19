import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/closet_item.dart';

class ClosetListView extends StatelessWidget {
  final List<ClosetItem> items;

  const ClosetListView({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3열로 배치
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1, // 정사각형 형태의 셀
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(8), // 모서리 둥글게
          child: Image.network(
            item.clothImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Padding(
                padding: const EdgeInsets.all(5.0), // 원하는 패딩 값
                child: SvgPicture.asset(
                  'assets/closet/add_cloth_btn.svg', // assets 폴더 내 fallback SVG 파일 경로
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
