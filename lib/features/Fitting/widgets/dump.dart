import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/bodyImageManager/body_image_provider.dart';
import '../fitting_closet/models/closet_item.dart';
import '../FittingResult/fitting_result_provider.dart';
import '../fitting_closet/providers/closet_items_provider.dart';
import '../fitting_closet/providers/clothing_confirmation_provider.dart';
import '../FittingResult/fitting_result_screen.dart';
import '../fitting_service.dart';

class FittingSelectedClothes extends StatefulWidget {
  final VoidCallback onToggleCloset;
  final Function(bool) setLoading; // 🔵 로딩 상태를 업데이트하는 함수 추가

  FittingSelectedClothes({required this.onToggleCloset, required this.setLoading});

  @override
  _FittingSelectedClothesState createState() => _FittingSelectedClothesState();
}

class _FittingSelectedClothesState extends State<FittingSelectedClothes> {
  bool _isLoading = false;

  /// 🟢 피팅 요청 실행
  Future<void> _startFitting() async {
    final bodyImageProvider = Provider.of<BodyImageProvider>(context, listen: false);
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

    for (var item in selectedItems) {
      final Map<String, dynamic> requestData = {
        "title": "생성된 옷",
        "is_favorite": false,
        "saved" : false,
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

      await fittingService.generateFittingImage(context, requestData);
    }

    setState(() {
      _isLoading = false;
    });

    widget.setLoading(false); // 🔴 화면 전체 로딩 비활성화

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: fittingResultProvider,
          child: FittingResultScreen(),
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
        if (selectedItems.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
