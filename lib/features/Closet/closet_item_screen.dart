import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/closet_items_provider.dart';
import 'widgets/items/closet_list_view.dart';
import 'widgets/items/empty_closet_view.dart';

class ClosetItemScreen extends StatefulWidget {
  const ClosetItemScreen({Key? key}) : super(key: key);

  @override
  _ClosetItemScreenState createState() => _ClosetItemScreenState();
}

class _ClosetItemScreenState extends State<ClosetItemScreen> {
  @override
  void initState() {
    super.initState();
    // 화면이 로드될 때 Provider를 통해 데이터를 가져옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClosetItemsProvider>(context, listen: false)
          .fetchClosetItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ClosetItemsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          } else if (provider.items.isEmpty) {
            return const EmptyClosetView();
          } else {
            return ClosetListView(items: provider.items);
          }
        },
      ),
    );
  }
}
