import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheelwear_frontend/utils/retryable_cached_network_image.dart';
import '../models/virtual_tryon_image.dart';
import '../virtual_tryon_provider.dart';
import '../widgets/cloth_comparison_widget.dart';
import '../widgets/cloth_detail_widget.dart';

class VirtualTryOnDetailScreen extends StatelessWidget {
  final VirtualTryOnImage tryOnImage;

  const VirtualTryOnDetailScreen({Key? key, required this.tryOnImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VirtualTryOnProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('상세보기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              // 삭제 확인 다이얼로그
              bool confirmed = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('삭제 확인'),
                    content: const Text('해당 항목을 삭제하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('취소'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('삭제'),
                      ),
                    ],
                  );
                },
              );
              if (confirmed) {
                try {
                  await provider.deleteImage(tryOnImage.id);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('삭제에 실패했습니다.')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 메인 이미지
            RetryableCachedNetworkImage(
              imageUrl: tryOnImage.image,
              fit: BoxFit.cover,
              borderRadius: 0,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                tryOnImage.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            // 바디 이미지
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                '바디 이미지',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: RetryableCachedNetworkImage(
                imageUrl: tryOnImage.bodyImage.bodyImage,
                fit: BoxFit.cover,
                borderRadius: 8,
              ),
            ),
            const Divider(),
            // Top Cloth 비교 및 상세 정보
            if (tryOnImage.topCloth != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  'Top Cloth 비교',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ClothComparisonWidget(
                bodyImageUrl: tryOnImage.bodyImage.bodyImage,
                clothImageUrl: tryOnImage.topCloth!.clothImage,
              ),
              ClothDetailWidget(
                  cloth: tryOnImage.topCloth!,
                  title: 'Top Cloth 상세 정보'),
            ],
            // Bottom Cloth 비교 및 상세 정보
            if (tryOnImage.bottomCloth != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  'Bottom Cloth 비교',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ClothComparisonWidget(
                bodyImageUrl: tryOnImage.bodyImage.bodyImage,
                clothImageUrl: tryOnImage.bottomCloth!.clothImage,
              ),
              ClothDetailWidget(
                  cloth: tryOnImage.bottomCloth!,
                  title: 'Bottom Cloth 상세 정보'),
            ],
            // Dress Cloth 비교 및 상세 정보
            if (tryOnImage.dressCloth != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  'Dress Cloth 비교',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ClothComparisonWidget(
                bodyImageUrl: tryOnImage.bodyImage.bodyImage,
                clothImageUrl: tryOnImage.dressCloth!.clothImage,
              ),
              ClothDetailWidget(
                  cloth: tryOnImage.dressCloth!,
                  title: 'Dress Cloth 상세 정보'),
            ],
          ],
        ),
      ),
    );
  }
}
