import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import ' widgets/fitting_closet_content.dart';
import ' widgets/fitting_main_content.dart';
import 'FittingResult/fitting_result_screen.dart';

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
          middle: Text("피팅룸", style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: _showClosetScreen
                        ? FittingClosetContent(
                        onExitClosetScreen: _exitClosetScreen)
                        : FittingMainContent(
                      onToggleCloset: _toggleContent,
                      setLoading: _setLoading,
                    ),
                  ),
                  // _buildButton(), // ⭐️⭐테스트용 버튼
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

  // /// ⭐️⭐️ 완성된 코디 View 보기 위한 Test 버튼! 지우셔도 됩니다! ⭐️⭐️
  // Widget _buildButton() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 10),
  //     child: CupertinoButton(
  //       color: Colors.purpleAccent, // 🔹 버튼 색상 추가
  //       child: Text(
  //           "Test", style: TextStyle(color: Colors.white, fontSize: 5)),
  //       onPressed: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => FittingResultScreen(safeMode: true),)
  //         );
  //       },
  //     ),
  //   );
  // }
}