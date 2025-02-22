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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final item in selectedItems)
            Container(
              margin: EdgeInsets.only(right: 10),
              width: 70,
              height: 70,
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
    );
  }
}
