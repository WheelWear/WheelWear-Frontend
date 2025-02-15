import 'package:flutter/cupertino.dart';

class FittingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('👕피팅룸👚'),
      ),
      child: Center(child: Text("피팅룸")),
    );
  }
}
