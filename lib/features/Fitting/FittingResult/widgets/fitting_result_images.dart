import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../fitting_result_provider.dart';
import '../fitting_result_model.dart'; // VirtualTryOnImage 모델 import (경로에 맞게 수정)
import 'package:wheelwear_frontend/utils/retryable_cached_network_image.dart'; // 실제 경로에 맞게 수정

/// 메인 이미지와 설명용 이미지를 토글하는 위젯
class ToggleImageWidget extends StatefulWidget {
  final String imageUrl;
  final String explanationImageUrl;

  const ToggleImageWidget({
    Key? key,
    required this.imageUrl,
    required this.explanationImageUrl,
  }) : super(key: key);

  @override
  _ToggleImageWidgetState createState() => _ToggleImageWidgetState();
}

class _ToggleImageWidgetState extends State<ToggleImageWidget> {
  // false: 기본 이미지, true: 설명 이미지
  bool _isToggled = false;

  @override
  Widget build(BuildContext context) {
    // 토글 상태에 따라 메인 이미지와 오버레이 이미지 결정
    final mainImageUrl = _isToggled ? widget.explanationImageUrl : widget.imageUrl;
    final overlayImageUrl = _isToggled ? widget.imageUrl : widget.explanationImageUrl;

    return AspectRatio(
      aspectRatio: 1, // 필요에 따라 비율 조정
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 메인 큰 이미지
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: RetryableCachedNetworkImage(
              imageUrl: mainImageUrl,
              fit: BoxFit.cover,
            ),
          ),
          // 오른쪽 하단 오버레이 작은 이미지
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isToggled = !_isToggled;
                });
              },
                child: Container(
                  width: 60,
                  // height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: RetryableCachedNetworkImage(
                    imageUrl: overlayImageUrl,
                    fit: BoxFit.contain,
                    borderRadius: 0,
                  ),
                ),
              ),

          ),
        ],
      ),
    );
  }
}

/// 생성된 피팅 이미지를 PageView 슬라이더로 보여주는 위젯
class FittingResultImages extends StatelessWidget {
  const FittingResultImages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fittingResultProvider = Provider.of<FittingResultProvider>(context);
    final fittingImages = fittingResultProvider.fittingImages;
    debugPrint("fittingImages: $fittingImages");

    return Scaffold(
      body: fittingImages.isEmpty
          ? const Center(child: Text("아직 생성된 피팅 이미지가 없습니다."))
          : _FittingResultImageSlider(
        fittingImages: fittingImages,
      ),
    );
  }
}


/// VirtualTryOnImage 객체 리스트를 받아 PageView로 슬라이더 형태로 보여주는 위젯
class _FittingResultImageSlider extends StatefulWidget {
  final List<VirtualTryOnImage> fittingImages;

  const _FittingResultImageSlider({
    Key? key,
    required this.fittingImages,
  }) : super(key: key);

  @override
  _FittingResultImageSliderState createState() => _FittingResultImageSliderState();
}

class _FittingResultImageSliderState extends State<_FittingResultImageSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // PageView 영역 (슬라이더)
        PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
            final currentImage = widget.fittingImages[index];
            Provider.of<FittingResultProvider>(context, listen: false).updateSelectedImage(currentImage);
          },
          children: widget.fittingImages.map((imageModel) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ToggleImageWidget(
                imageUrl: imageModel.image,
                explanationImageUrl: imageModel.dressCloth?.clothImage ??
                    imageModel.topCloth?.clothImage ??
                    imageModel.bottomCloth?.clothImage ??
                    '',
              ),
            );
          }).toList(),
        ),
        // 인디케이터 영역 (동그라미와 불투명한 타원형 배경)
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(widget.fittingImages.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: _currentPage == index ? 8.0 : 8.0,
                    height: _currentPage == index ? 8.0 : 8.0,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.white : Colors.grey[500],
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
