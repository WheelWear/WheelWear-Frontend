import 'package:flutter/material.dart';
import 'package:wheelwear_frontend/utils/retryable_cached_network_image.dart';

class ClothComparisonWidget extends StatelessWidget {
  final String bodyImageUrl;
  final String clothImageUrl;

  const ClothComparisonWidget({
    Key? key,
    required this.bodyImageUrl,
    required this.clothImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 바디 이미지와 의상 이미지를 나란히 보여주는 위젯
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text('바디 이미지'),
                const SizedBox(height: 8),
                RetryableCachedNetworkImage(
                  imageUrl: bodyImageUrl,
                  fit: BoxFit.cover,
                  borderRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                const Text('의상 이미지'),
                const SizedBox(height: 8),
                RetryableCachedNetworkImage(
                  imageUrl: clothImageUrl,
                  fit: BoxFit.cover,
                  borderRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
