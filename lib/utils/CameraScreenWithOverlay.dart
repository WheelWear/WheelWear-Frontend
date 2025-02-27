import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart'; // 추가

/// 커스텀 카메라 위젯 (오버레이 가이드라인 이미지를 매개변수로 전달)
class CameraScreenWithOverlay extends StatefulWidget {
  final String guidelineAsset;

  const CameraScreenWithOverlay({Key? key, required this.guidelineAsset})
      : super(key: key);

  @override
  _CameraScreenWithOverlayState createState() =>
      _CameraScreenWithOverlayState();
}

class _CameraScreenWithOverlayState extends State<CameraScreenWithOverlay> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(_cameras![0], ResolutionPreset.high);
      await _controller!.initialize();
      if (!mounted) return;
      setState(() => _isCameraInitialized = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("커스텀 카메라"), centerTitle: true),
      body:
      _isCameraInitialized
          ? Stack(
        children: [
          CameraPreview(_controller!),
          // 매개변수로 받은 가이드라인 이미지 오버레이
          Center(
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                widget.guidelineAsset,
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_controller != null) {
            // 사진 촬영
            XFile file = await _controller!.takePicture();
            // EXIF 정보를 기반으로 이미지 회전 보정 (갤럭시 등에서 뒤집힘 문제 해결)
            final fixedFile = await FlutterExifRotation.rotateImage(
              path: file.path,
            );
            Navigator.pop(context, fixedFile.path);
          }
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}
