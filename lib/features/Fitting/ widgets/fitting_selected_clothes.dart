import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/body_image_provider.dart';
import '../../Closet/models/closet_item.dart';
import '../FittingResult/fitting_result_provider.dart';
import '../FittingResult/widgets/fitting_result_images.dart';
import '../fitting_closet/providers/closet_items_provider.dart';
import '../fitting_closet/providers/clothing_confirmation_provider.dart';
import '../FittingResult/fitting_result_screen.dart';
import '../fitting_service.dart';

class FittingSelectedClothes extends StatefulWidget {
  final VoidCallback onToggleCloset;

  FittingSelectedClothes({required this.onToggleCloset});

  @override
  _FittingSelectedClothesState createState() => _FittingSelectedClothesState();
}

class _FittingSelectedClothesState extends State<FittingSelectedClothes> {
  bool _isLoading = false; // 로딩 상태

  /// 🟢 피팅 요청 실행 (한 번에 하나씩 요청)
  Future<void> _startFitting() async {
    final bodyImageProvider = Provider.of<BodyImageProvider>(context, listen: false);
    final clothingConfirmationProvider = Provider.of<ClothingConfirmationProvider>(context, listen: false);
    final closetItemsProvider = Provider.of<ClosetItemsProvider>(context, listen: false);
    final fittingResultProvider = Provider.of<FittingResultProvider>(context, listen: false);
    final fittingService = FittingService();

    // // ✅ 이전 결과 초기화
    // fittingResultProvider.clearFittingImages();

    // ✅ 바디 이미지 ID가 없으면 요청 차단
    if (bodyImageProvider.bodyImageID == null) {
      print("🔴 바디 이미지가 설정되지 않았습니다!");
      return;
    }

    // ✅ 선택된 옷 ID 가져오기
    final chosenIds = clothingConfirmationProvider.confirmedClothes;
    final selectedItems = closetItemsProvider.items
        .where((item) => chosenIds.contains(item.id))
        .take(4)
        .toList();

    if (selectedItems.isEmpty) {
      print("🔴 최소한 하나의 옷을 선택해야 합니다.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    for (var item in selectedItems) {
      final Map<String, dynamic> requestData = {
        "title": "생성된 옷",
        "is_favorite": false,
        "body_image": bodyImageProvider.bodyImageID,
        "top_cloth": "",
        "bottom_cloth": "",
        "dress_cloth": "",
      };

      // ✅ 선택된 옷 중 한 종류만 요청에 포함
      if (item.clothType == "top_cloth") {
        requestData["top_cloth"] = item.id;
      } else if (item.clothType == "bottom_cloth") {
        requestData["bottom_cloth"] = item.id;
      } else if (item.clothType == "dress_cloth") {
        requestData["dress_cloth"] = item.id;
      }

      print("🟡 최종 요청 데이터: $requestData");

      // ✅ 요청 보내기
      final imageUrl = await fittingService.generateFittingImage(context, requestData);

      // if (imageUrl != null) {
      //   fittingResultProvider.addFittingImage(imageUrl);
      // } else {
      //   print("🔴 피팅 요청 실패: $item");
      // }
    }


    setState(() {
      _isLoading = false;
    });

    // ✅ 결과 페이지로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: fittingResultProvider,
          child: FittingResultImages(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bodyImageProvider = Provider.of<BodyImageProvider>(context);
    final clothingConfirmationProvider = Provider.of<ClothingConfirmationProvider>(context);
    final closetItemsProvider = Provider.of<ClosetItemsProvider>(context);

    final chosenIds = clothingConfirmationProvider.confirmedClothes;
    final selectedItems = closetItemsProvider.items
        .where((item) => chosenIds.contains(item.id))
        .take(4)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ 선택된 옷 리스트
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final item in selectedItems)
                Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(item.clothImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              GestureDetector(
                onTap: widget.onToggleCloset,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 45,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),

        SizedBox(height: 5),

        // ✅ "피팅하기" 버튼
        if (selectedItems.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _isLoading ? null : _startFitting,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  "피팅하기",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
