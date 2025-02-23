import 'package:flutter/foundation.dart';

class FittingResultProvider extends ChangeNotifier {
  List<String> _fittingImages = [];

  List<String> get fittingImages => _fittingImages;

  void setFittingImages(List<String> images) {
    _fittingImages = images;
    notifyListeners();
  }
}
