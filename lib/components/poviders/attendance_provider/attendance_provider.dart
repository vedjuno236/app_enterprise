
import 'package:enterprise/components/logger/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

final stateAttendanceProvider =
    ChangeNotifierProvider<AttendanceProvider>((ref) {
  return AttendanceProvider();
});

class AttendanceProvider with ChangeNotifier {
  /// isLoading
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  final ImagePicker _imagePicker = ImagePicker();

  XFile? _selectedImage;

  XFile? get selectedImage => _selectedImage;

  Future<void> pickImageFromGallery() async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _selectedImage = pickedFile;
        notifyListeners();
      }
    } catch (e) {
      logger.d("Error picking image from gallery: $e");
    }
  }

  // Pick an image from the camera
  // Future<void> pickImageFromCamera() async {
  //   try {
  //     final pickedFile =
  //         await _imagePicker.pickImage(source: ImageSource.camera);
  //     if (pickedFile != null) {
  //       _selectedImage = pickedFile;
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     logger.d("Error picking image from camera: $e");
  //   }
  // }
 

 Future<void> pickImageFromCamera() async {
  try {
    final cameraStatus = await Permission.camera.request();

    if (!cameraStatus.isGranted) {
      logger.d("Camera permission not granted");
      return;
    }

    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _selectedImage = pickedFile;
      notifyListeners();
    }
  } catch (e) {
    logger.d("Error picking image from camera: $e");
  }
}

 
 
 
 void clearImage() {
    _selectedImage = null;
    notifyListeners();
  }
  @override
  void dispose() {
    _selectedImage = null;
    super.dispose();
  }
}
