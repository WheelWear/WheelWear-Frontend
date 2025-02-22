import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'fitting_closet/fitting_closet_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

// FittingCloset 관련 provider에 alias 부여
import './fitting_closet/providers/closet_filter_provider.dart' as fitting;
import './fitting_closet/providers/selection_provider.dart' as fitting;
import './fitting_closet/providers/closet_items_provider.dart' as fitting;
import './fitting_closet/providers/clothing_confirmation_provider.dart' as fitting;

class FittingScreen extends StatefulWidget {
  @override
  _FittingScreenState createState() => _FittingScreenState();
}

class _FittingScreenState extends State<FittingScreen> {
  // false: 기본 피팅 콘텐츠, true: 피팅 클로젯 콘텐츠를 보여줌
  bool _showClosetScreen = false;

  // 피팅 클로젯 콘텐츠를 종료하는 콜백
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

  // 뒤로가기 버튼 동작 제어
  Future<bool> _onWillPop() async {
    if (_showClosetScreen) {
      // 피팅 클로젯 화면에서 뒤로가면 기본 피팅 콘텐츠로 전환
      setState(() {
        _showClosetScreen = false;
      });
      return false; // 뒤로가더라도 페이지 종료 안 함
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
          child: _showClosetScreen ? _buildClosetScreen() : _buildMainContent(),
        ),
      ),
    );
  }

  // -----------------------
  // 1) 메인 피팅 콘텐츠
  // -----------------------
  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 중앙 이미지 영역
          Center(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.6,
              color: Color(0xC7EEEEEE),
              child: Center(
                child: Image.asset(
                  "assets/closet/emptyCloset.png",
                  width: 300,
                  height: 350,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // 하단 섹션
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "옷 고르기" 및 "사진 변경" 버튼 행
                Row(
                  children: [
                    Text(
                      "옷 고르기",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        final confirmationProvider = Provider.of<fitting.ClothingConfirmationProvider>(context, listen: false);
                        debugPrint("확정된 아이템들: ${confirmationProvider.confirmedClothes}");
                        // 사진 변경 기능 추가 가능
                      },
                      child: Container(
                        width: 90,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Color(0xFFC3C3C3),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "사진 변경",
                            style: TextStyle(fontSize: 14, color: CupertinoColors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  "피팅하고 싶은 옷을 모두 골라주세요!",
                  style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
                ),
                SizedBox(height: 10),

                // 2) 선택된 옷(최대 4개) + "+버튼" 한 줄에 배치
                _buildSelectedClothesRow(),

              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 2) 선택된 옷(최대 4개) + "+버튼"을 한 줄에 표시
  Widget _buildSelectedClothesRow() {
    // (1) 확정된 아이템의 id 목록
    final chosenIds = Provider.of<fitting.ClothingConfirmationProvider>(context).confirmedClothes;

    // (2) 전체 ClosetItemsProvider에서 로드된 아이템들
    final closetItems = Provider.of<fitting.ClosetItemsProvider>(context).items;

    // (3) chosenIds에 해당하는 아이템만 추출 (최대 4개)
    final selectedItems = closetItems.where((item) => chosenIds.contains(item.id)).take(4).toList();

    // 만약 선택된 옷이 아무것도 없으면, +버튼만 표시
    if (selectedItems.isEmpty) {
      return Row(
        children: [
          _buildAddClothesButton(context),
        ],
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // 선택된 옷들의 미리보기
          for (final item in selectedItems) ...[
            Container(
              margin: EdgeInsets.only(right: 10),
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(item.clothImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],

          // +버튼 (옷 고르기)
          _buildAddClothesButton(context),
        ],
      ),
    );
  }

  // "+버튼" 위젯
  Widget _buildAddClothesButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 옷 고르기 화면으로 전환
        _toggleContent();
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(
            color: CupertinoColors.systemGrey4,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            CupertinoIcons.add,
            size: 30,
            color: CupertinoColors.systemGrey4,
          ),
        ),
      ),
    );
  }

  // -----------------------
  // 3) 피팅 클로젯 화면
  // -----------------------
  Widget _buildClosetScreen() {
    // 이미 최상위에서 생성된 Provider 인스턴스 사용
    final closetItemsProvider = Provider.of<fitting.ClosetItemsProvider>(context, listen: false);
    final clothingConfirmationProvider = Provider.of<fitting.ClothingConfirmationProvider>(context, listen: false);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<fitting.ClosetFilterProvider>(
          create: (_) => fitting.ClosetFilterProvider(),
        ),
        ChangeNotifierProvider<fitting.SelectionProvider>(
          create: (_) => fitting.SelectionProvider(),
        ),
        ChangeNotifierProvider<fitting.ClosetItemsProvider>.value(
          value: closetItemsProvider,
        ),
        ChangeNotifierProvider<fitting.ClothingConfirmationProvider>.value(
          value: clothingConfirmationProvider,
        ),
      ],
      child: FittingClosetScreen(onExitClosetScreen: _exitClosetScreen),
    );
  }
}

