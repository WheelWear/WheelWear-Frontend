import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/closet_items_provider.dart';
import 'widgets/items/closet_list_view.dart';

class FittingClosetItem extends StatefulWidget {
  // FittingScreen에서 전달한 콜백을 저장하는 변수
  final VoidCallback onExitClosetScreen;

  // 생성자에서 콜백을 받아옵니다.
  const FittingClosetItem({Key? key, required this.onExitClosetScreen}) : super(key: key);

  @override
  _FittingClosetItemState createState() => _FittingClosetItemState();
}

class _FittingClosetItemState extends State<FittingClosetItem> {
  @override
  void initState() {
    super.initState();
    // 화면 로드 후 Provider를 통해 데이터를 가져옵니다.
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
            return const Center(child: CircularProgressIndicator());
          } else if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          } else {
            // ClosetListView 내부에서 empty 상태도 처리합니다.
            return ClosetListView(items: provider.items, onExitClosetScreen: widget.onExitClosetScreen);
          }
        },
      ),
    );
  }
}
