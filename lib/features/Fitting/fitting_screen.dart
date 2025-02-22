import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import ' widgets/fitting_closet_content.dart';
import ' widgets/fitting_main_content.dart';


class FittingScreen extends StatefulWidget {
  @override
  _FittingScreenState createState() => _FittingScreenState();
}

class _FittingScreenState extends State<FittingScreen> {
  bool _showClosetScreen = false;

  void _exitClosetScreen() {
    setState(() {
      _showClosetScreen = false;
    });
  }

  void _toggleContent() {
    setState(() {
      _showClosetScreen = true;
    });
  }

  Future<bool> _onWillPop() async {
    if (_showClosetScreen) {
      setState(() {
        _showClosetScreen = false;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("피팅룸", style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        child: SafeArea(
          child: _showClosetScreen
              ? FittingClosetContent(onExitClosetScreen: _exitClosetScreen)
              : FittingMainContent(onToggleCloset: _toggleContent),
        ),
      ),
    );
  }
}


