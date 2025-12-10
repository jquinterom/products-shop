import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teslo_app/features/shared/infrastructure/services/camera_gallery_service.dart';

class CameraGalleryServiceImpl implements CameraGalleryService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> takePhoto() async {
    return _pickImage(ImageSource.camera);
  }

  @override
  Future<String?> selectPhoto() async {
    return _pickImage(ImageSource.gallery);
  }

  Future<String?> _pickImage(ImageSource source) async {
    final XFile? photo = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    debugPrint("${source.name}: ${photo?.path}");

    return photo?.path;
  }
}
