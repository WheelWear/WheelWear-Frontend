import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../fitting_closet/providers/closet_items_provider.dart';
import '../fitting_closet/providers/clothing_confirmation_provider.dart';
import 'fitting_add_clothes_button.dart';

class FittingSelectedClothes extends StatelessWidget {
  final VoidCallback onToggleCloset;

  FittingSelectedClothes({required this.onToggleCloset});

  @override
  Widget build(BuildContext context) {
    final chosenIds = Provider.of<ClothingConfirmationProvider>(context).confirmedClothes;
    final closetItems = Provider.of<ClosetItemsProvider>(context).items;
    final selectedItems = closetItems.where((item) => chosenIds.contains(item.id)).take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // ✅ 옷을 왼쪽 정렬
      children: [
        // ✅ 선택된 옷 리스트 (왼쪽 정렬)
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
              FittingAddClothesButton(onToggleCloset: onToggleCloset),
            ],
          ),
        ),

        SizedBox(height: 3),

        // ✅ "피팅하기" 버튼
        if (selectedItems.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: _buildTryOnButton(context),
            ),
          ),
      ],
    );
  }

  /// 🟢 "피팅하기" 버튼
  Widget _buildTryOnButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {
        print("🟢 피팅하기 버튼 클릭!");
        // ✅ 피팅 로직 추가
      },
      child: Text(
        "Try On",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}



