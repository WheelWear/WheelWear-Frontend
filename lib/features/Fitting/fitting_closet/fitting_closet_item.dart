import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheelwear_frontend/features/Fitting/fitting_closet/providers/closet_items_provider.dart';
import 'package:wheelwear_frontend/features/Fitting/fitting_closet/widgets/items/closet_list_view.dart';

class FittingClosetItem extends StatefulWidget {
  final VoidCallback onExitClosetScreen;
  const FittingClosetItem({Key? key, required this.onExitClosetScreen})
      : super(key: key);

  @override
  _FittingClosetItemState createState() => _FittingClosetItemState();
}

class _FittingClosetItemState extends State<FittingClosetItem> {
  @override
  void initState() {
    super.initState();
    // Provider를 통해 옷 목록 데이터를 불러옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClosetItemsProvider>(context, listen: false).fetchClosetItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ClosetItemsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          } else {
            return ClosetListView(
              items: provider.items,
              onExitClosetScreen: widget.onExitClosetScreen,
            );
          }
        },
      ),
    );
  }
}
