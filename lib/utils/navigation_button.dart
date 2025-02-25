import 'package:flutter/cupertino.dart';

class NavigationButton extends StatelessWidget {
  final String label;
  final Widget targetPage;
  final double width;
  final double height;

  const NavigationButton({
    Key? key,
    required this.label,
    required this.targetPage,
    this.width = 344,
    this.height = 33,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => targetPage),
        );
      },
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Color(0xFF3617CE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: CupertinoColors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}