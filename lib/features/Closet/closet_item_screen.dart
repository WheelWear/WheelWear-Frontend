import 'package:flutter/cupertino.dart';
import 'models/closet_item.dart';
import 'services/api_service.dart';
import 'widgets/items/closet_list_view.dart';
import 'widgets/items/empty_closet_view.dart';

class ClosetItemScreen extends StatefulWidget {
  const ClosetItemScreen({Key? key}) : super(key: key);

  @override
  _ClosetItemScreenState createState() => _ClosetItemScreenState();
}

class _ClosetItemScreenState extends State<ClosetItemScreen> {
  late Future<List<ClosetItem>> _closetItemsFuture;

  @override
  void initState() {
    super.initState();
    // 위젯이 생성될 때 API 호출, 이후 재사용
    _closetItemsFuture = ApiService().fetchClosetItems();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<ClosetItem>>(
        future: _closetItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final items = snapshot.data!;
            return ClosetListView(items: items);
          } else {
            return EmptyClosetView();
          }
        },
      ),
    );
  }
}
