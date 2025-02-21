import 'package:flutter/foundation.dart';
import '../models/closet_item.dart';
import '../services/api_service.dart';

class ClosetItemsProvider extends ChangeNotifier {
  List<ClosetItem> _items = [];
  bool _isLoading = false;
  String? _error;

  List<ClosetItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchClosetItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await ApiService().fetchClosetItems();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}