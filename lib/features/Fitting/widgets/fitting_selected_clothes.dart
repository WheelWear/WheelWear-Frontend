import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../../utils/bodyImageManager/body_image_provider.dart';
import '../fitting_closet/models/closet_item.dart';
import '../FittingResult/fitting_result_provider.dart';
import '../fitting_closet/providers/closet_items_provider.dart';
import '../fitting_closet/providers/clothing_confirmation_provider.dart';
import '../FittingResult/fitting_result_screen.dart';
import '../fitting_service.dart';
import '../FittingResult/fitting_result_model.dart';
import 'package:wheelwear_frontend/utils/system_alert_dialog.dart';
import 'package:wheelwear_frontend/utils/retryable_cached_network_image.dart';
import '../fitting_closet/providers/clothing_confirmation_provider.dart';

class FittingSelectedClothes extends StatefulWidget {
  final VoidCallback onToggleCloset;
  final Function(bool) setLoading; // 🔵 로딩 상태를 업데이트하는 함수 추가

  FittingSelectedClothes({required this.onToggleCloset, required this.setLoading});

  @override
  _FittingSelectedClothesState createState() => _FittingSelectedClothesState();
}

class _FittingSelectedClothesState extends State<FittingSelectedClothes> {
  bool _isLoading = false;

  void _fetchData() {
    final bodyImageProvider = Provider.of<BodyImageProvider>(context, listen: false);
    bodyImageProvider.fetchBodyImage();
    final clothingConfirmationProvider = Provider.of<ClothingConfirmationProvider>(context, listen: false);
    clothingConfirmationProvider.clearConfirmation();

    debugPrint("디버그: _fetchData 호출");
    debugPrint(bodyImageProvider.toJson().toString());
    debugPrint(clothingConfirmationProvider.toJson().toString());
  }

  /// 🟢 피팅 요청 실
  Future<void> _startFitting() async {
    int false_count = 0;
    final clothingConfirmationProvider = Provider.of<ClothingConfirmationProvider>(context, listen: false);
    final closetItemsProvider = Provider.of<ClosetItemsProvider>(context, listen: false);
    final fittingResultProvider = Provider.of<FittingResultProvider>(context, listen: false);
    final fittingService = FittingService();
    final chosenIds = clothingConfirmationProvider.confirmedClothes;
    final selectedItems = closetItemsProvider.items
        .where((item) => chosenIds.contains(item.id))
        .take(3)
        .toList();

    if (selectedItems.isEmpty) {
      print("🔴 최소한 하나의 옷을 선택해야 합니다.");
      return;
    }

    setState(() {
      _isLoading = true;
    });
    widget.setLoading(true);

    fittingResultProvider.clearFittingImages();

    // 선택한 아이템마다 피팅 이미지 요청 실행
    for (var item in selectedItems) {
      // 요청 전 결과 이미지 초기화 (각 아이템 요청마다 초기화할 경우, 누적되지 않으므로 필요에 따라 위치를 조정하세요)

      final Map<String, dynamic> requestData = {
        "title": "생성된 옷",
        "is_favorite": false,
        "saved": false,
      };

      switch (item.clothType) {
        case ClothType.Top:
          requestData["top_cloth"] = item.id;
          break;
        case ClothType.Bottom:
          requestData["bottom_cloth"] = item.id;
          break;
        case ClothType.Dress:
          requestData["dress_cloth"] = item.id;
          break;
        default:
          throw Exception("알 수 없는 ClothType: ${item.clothType}");
      }

      print("🟡 최종 요청 데이터: $requestData");

      final responseData = await fittingService.generateFittingImage(context, requestData);

      if (responseData != null) {
        try {
          // 반환된 전체 JSON 데이터를 사용하여 VirtualTryOnImage 객체 생성
          final newImage = VirtualTryOnImage.fromJson(responseData);
          fittingResultProvider.addFittingImage(newImage);
          debugPrint("피팅 이미지 추가됨: ${newImage.image}");
        } catch (e) {
          false_count += 1;
          debugPrint("피팅 이미지 객체 생성 중 오류: $e");
        }
      }
      else {false_count+=1;}
    }

    debugPrint("디버그: 피팅 결과 이미지 개수: ${fittingResultProvider.fittingImages.length}");
    debugPrint(fittingResultProvider.toJson().toString());
    if (fittingResultProvider.fittingImages.isNotEmpty) {
      setState(() {
        _isLoading = false;
      });
      widget.setLoading(false);
      if (false_count > 0 ){
        await SystemAlertDialog.show(
          context: context,
          title: "경고",
          message: "$false_count개의 이미지 생성이 실패하였습니다....",
          alertType: AlertType.warning,
        );
      }
    } else {
      debugPrint("디버그: 피팅 결과 이미지가 없습니다.");
      setState(() {
        _isLoading = false;
      });
      widget.setLoading(false);
      await SystemAlertDialog.show(
        context: context,
        title: "경고",
        message: "피팅 결과 이미지가 없습니다. 최소 한 개 이상의 결과가 필요합니다.",
        alertType: AlertType.warning,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: fittingResultProvider,
          child: FittingResultScreen(),
        ),
      ),
    ).then((_) {
      // 피팅 결과 화면이 종료되면 이곳에서 데이터를 다시 받아오는 로직을 실행합니다.
      _fetchData();
    });


  }

  @override
  Widget build(BuildContext context) {
    final closetItemsProvider = Provider.of<ClosetItemsProvider>(context);
    final clothingConfirmationProvider = Provider.of<ClothingConfirmationProvider>(context);

    final chosenIds = clothingConfirmationProvider.confirmedClothes;
    final selectedItems = closetItemsProvider.items
        .where((item) => chosenIds.contains(item.id))
        .take(3)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final item in selectedItems)
                Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: RetryableCachedNetworkImage(
                      imageUrl: item.clothImage,
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
        if (selectedItems.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _isLoading ? null : _startFitting,
                child: Text(
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
