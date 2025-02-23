import 'package:flutter/material.dart';

class FittingResultImages extends StatefulWidget {
  final List<String> fittingImages;

  FittingResultImages({required this.fittingImages});

  @override
  _FittingResultImagesState createState() => _FittingResultImagesState();
}

class _FittingResultImagesState extends State<FittingResultImages> {
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
