import 'package:flutter/cupertino.dart';
import 'models/closet_item.dart';
import 'services/api_service.dart';
import 'widgets/items/empty_closet_view.dart';
import 'widgets/items/closet_list_view.dart';

class ClosetItemScreen extends StatelessWidget {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<ClosetItem>>(
        future: _apiService.fetchClosetItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final items = snapshot.data!;
            return items.isEmpty
                ? EmptyClosetView()
                : ClosetListView(items: items);
          } else {
            return Center(child: Text('No data found.'));
          }
        },
      ),
    );
  }
}
