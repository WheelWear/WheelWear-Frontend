import 'package:flutter/material.dart';
import '../models/virtual_tryon_image.dart';
import 'virtual_tryon_item.dart';

class VirtualTryOnGrid extends StatelessWidget {
  final List<VirtualTryOnImage> images;

  const VirtualTryOnGrid({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2칸 그리드
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.75,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return VirtualTryOnItem(image: images[index]);
      },
    );
  }
}
