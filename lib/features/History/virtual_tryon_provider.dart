import 'package:flutter/material.dart';
import './models/virtual_tryon_image.dart';
import './api_service.dart';

class VirtualTryOnProvider with ChangeNotifier {
  List<VirtualTryOnImage> _images = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<VirtualTryOnImage> get images => _images;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final ApiService _apiService = ApiService();

  VirtualTryOnProvider() {
    fetchImages();
  }

  Future<void> fetchImages() async {
    print("?tq");
    _isLoading = true;
    notifyListeners();

    try {
      _images = await _apiService.fetchVirtualTryOnImages();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteImage(int id) async {
    try {
      await _apiService.deleteVirtualTryOnImage(id);
      _images.removeWhere((image) => image.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      throw e;
    }
  }
}