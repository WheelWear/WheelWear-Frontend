// FittingScreen.dart (수정된 부분)
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/fitting_closet_content.dart';
import 'widgets/fitting_main_content.dart';
import 'FittingResult/fitting_result_screen.dart';
import '../History/screens/virtual_tryon_screen.dart'; // 기록 화면 import

class FittingScreen extends StatefulWidget {
  @override
  _FittingScreenState createState() => _FittingScreenState();
}

class _FittingScreenState extends State<FittingScreen> {
  bool _showClosetScreen = false;
  bool _isLoading = false;

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

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
          middle: const Text("피팅룸", style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: _showClosetScreen
                        ? FittingClosetContent(onExitClosetScreen: _exitClosetScreen)
                        : FittingMainContent(
                      onToggleCloset: _toggleContent,
                      setLoading: _setLoading,
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Image.asset(
                      'assets/fitting/CreationAnim.gif',
                      width: 400,
                      height: 400,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
