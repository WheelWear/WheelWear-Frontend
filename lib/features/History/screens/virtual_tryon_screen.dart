import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../virtual_tryon_provider.dart';
import '../widgets/virtual_tryon_grid.dart';

class VirtualTryOnScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final virtualTryOnProvider = Provider.of<VirtualTryOnProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('가상 피팅 이미지'),
      ),
      body: virtualTryOnProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : virtualTryOnProvider.errorMessage != null
          ? Center(child: Text(virtualTryOnProvider.errorMessage!))
          : VirtualTryOnGrid(images: virtualTryOnProvider.images),
    );
  }
}
