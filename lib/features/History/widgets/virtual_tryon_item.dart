import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/virtual_tryon_image.dart';
import '../screens/virtual_tryon_detail_screen.dart';
import 'package:wheelwear_frontend/utils/retryable_cached_network_image.dart';
import '../virtual_tryon_provider.dart'; // Provider import 추가

class VirtualTryOnItem extends StatelessWidget {
  final VirtualTryOnImage image;

  const VirtualTryOnItem({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ChangeNotifierProvider.value(
        //       value: Provider.of<VirtualTryOnProvider>(context, listen: false),
        //       child: Builder(
        //         builder: (context) => VirtualTryOnDetailScreen(tryOnImage: image),
        //       ),
        //     ),
        //   ),
        // );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Expanded(
              child: RetryableCachedNetworkImage(
                imageUrl: image.image,
                fit: BoxFit.cover,
                borderRadius: 0, // Card 내부에서는 borderRadius 적용 안 함
              ),
            ),
          ],
        ),
      ),
    );
  }
}
