import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RetryableCachedNetworkImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;
  final double borderRadius;

  const RetryableCachedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  _RetryableCachedNetworkImageState createState() =>
      _RetryableCachedNetworkImageState();
}

class _RetryableCachedNetworkImageState extends State<RetryableCachedNetworkImage> {
  int _retryCount = 0;

  void _retry() {
    setState(() {
      _retryCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: CachedNetworkImage(
        key: ValueKey(_retryCount),
        imageUrl: widget.imageUrl,
        fit: widget.fit,
        placeholder: (context, url) {
          // debugPrint('Loading image: $url');
          return Container(
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        imageBuilder: (context, imageProvider) {
          // debugPrint('Image loaded successfully: ${widget.imageUrl}');
          return Image(
            image: imageProvider,
            fit: widget.fit,
          );
        },
        errorWidget: (context, url, error) {
          debugPrint('Image load error for $url: $error');
          return GestureDetector(
            onTap: _retry,
            child: Container(
              color: Colors.grey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.error, color: Colors.red, size: 40),
                    SizedBox(height: 8),
                    Text('이미지 로드 실패. 다시 시도하려면 탭하세요.'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}