import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:photo_app/pages/camera_page.dart';
import '../services/storage_service.dart';
import 'gallery_page.dart';
import 'camera_page.dart';

class CameraFlow extends StatefulWidget {
  final VoidCallback shouldLogOut;
  const CameraFlow({Key? key, required this.shouldLogOut}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CameraFlowState();
}

class _CameraFlowState extends State<CameraFlow> {
  bool _shouldShowCamera = false;
  late CameraDescription _camera;
  late StorageService _storageService;

  List<MaterialPage> get _pages {
    return [
      // Show Gallery Page
      MaterialPage(
          child: GalleryPage(
        shouldLogOut: widget.shouldLogOut,
        shouldShowCamera: () => _toggleCameraOpen(true),
        imageUrlsController: _storageService.imageUrlsController,
      )),
      // Show Camera Page
      if (_shouldShowCamera)
        MaterialPage(
            child: CameraPage(
                camera: _camera,
                didProvideImagePath: (imagePath) {
                  _toggleCameraOpen(false);
                  _storageService.uploadImageAtPath(imagePath as String);
                }))
    ];
  }

  @override
  void initState() {
    super.initState();
    _getCamera();
    _storageService = StorageService();
    _storageService.getImages();
  }

  @override
  Widget build(BuildContext context) {
    // 4
    return Navigator(
      pages: _pages,
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  // 5
  void _toggleCameraOpen(bool isOpen) {
    setState(() {
      _shouldShowCamera = isOpen;
    });
  }

  void _getCamera() async {
    final camerasList = await availableCameras();
    setState(() {
      final firstCamera = camerasList.first;
      _camera = firstCamera;
    });
  }
}
