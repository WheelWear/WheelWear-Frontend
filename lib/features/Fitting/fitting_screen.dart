import 'package:flutter/cupertino.dart';

class FittingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("피팅룸", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      child: Center(
        child: Text("피팅룸", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
