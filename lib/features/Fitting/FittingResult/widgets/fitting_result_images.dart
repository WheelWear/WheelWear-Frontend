import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../fitting_result_provider.dart';

class FittingResultImages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fittingResultProvider = Provider.of<FittingResultProvider>(context);
    final fittingImages = fittingResultProvider.fittingImages;

    return Scaffold(
      appBar: AppBar(title: Text("피팅 결과")),
      body: fittingImages.isEmpty
          ? Center(child: Text("아직 생성된 피팅 이미지가 없습니다."))
          : _FittingResultImageSlider(fittingImages: fittingImages),
    );
  }
}

class _FittingResultImageSlider extends StatefulWidget {
  final List<String> fittingImages;

  _FittingResultImageSlider({required this.fittingImages});

  @override
  _FittingResultImageSliderState createState() => _FittingResultImageSliderState();
}

class _FittingResultImageSliderState extends State<_FittingResultImageSlider> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 400,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.fittingImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.fittingImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.fittingImages.length,
                (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _currentIndex == index ? 10 : 6,
              height: 6,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

