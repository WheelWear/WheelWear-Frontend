import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../fitting_closet/fitting_closet_screen.dart';
import '../fitting_closet/providers/closet_items_provider.dart';
import '../fitting_closet/providers/clothing_confirmation_provider.dart';
import '../fitting_closet/providers/closet_filter_provider.dart';
import '../fitting_closet/providers/selection_provider.dart';

class FittingClosetContent extends StatelessWidget {
  final VoidCallback onExitClosetScreen;

  FittingClosetContent({required this.onExitClosetScreen});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ClosetFilterProvider>(
          create: (_) => ClosetFilterProvider(),
        ),
        ChangeNotifierProvider<SelectionProvider>(
          create: (_) => SelectionProvider(),
        ),
        ChangeNotifierProvider<ClosetItemsProvider>.value(
          value: Provider.of<ClosetItemsProvider>(context, listen: false),
        ),
        ChangeNotifierProvider<ClothingConfirmationProvider>.value(
          value: Provider.of<ClothingConfirmationProvider>(context, listen: false),
        ),
      ],
      child: FittingClosetScreen(onExitClosetScreen: onExitClosetScreen),
    );
  }
}
