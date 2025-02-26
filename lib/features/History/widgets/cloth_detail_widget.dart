import 'package:flutter/material.dart';
import 'package:wheelwear_frontend/utils/retryable_cached_network_image.dart';
import '../models/cloth.dart';

class ClothDetailWidget extends StatelessWidget {
  final Cloth cloth;
  final String title;

  const ClothDetailWidget({Key? key, required this.cloth, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            RetryableCachedNetworkImage(
              imageUrl: cloth.clothImage,
              fit: BoxFit.cover,
              borderRadius: 8,
            ),
            const SizedBox(height: 8),
            Text('브랜드: ${cloth.brand ?? "정보 없음"}'),
            Text('사이즈: ${cloth.size ?? "정보 없음"}'),
            Text('타입: ${cloth.clothType}'),
            Text('카테고리: ${cloth.closetCategory}'),
            Text('생성일: ${cloth.createdAt.toLocal().toString().split(" ")[0]}'),
            if (cloth.clothSubtypes.isNotEmpty)
              Text('서브타입: ${cloth.clothSubtypes.join(", ")}'),
          ],
        ),
      ),
    );
  }
}
