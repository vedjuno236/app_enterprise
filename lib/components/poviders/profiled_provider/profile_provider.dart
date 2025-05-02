import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final stateProfileProvider = ChangeNotifierProvider<ProfileProvider>((ref) {
  return ProfileProvider();
});

class ProfileProvider with ChangeNotifier {
  // Private variables
  String _txtStatus = '';
  String _txtSkills = '';

  int _charCountStatus = 0;
  int _charCountSkills = 0;

  // Getters
  int get charCountStatus => _charCountStatus;

  int get charCountSkills => _charCountSkills;

  String get txtStatus => _txtStatus;

  String get txtSkills => _txtSkills;

  // Methods to update status
  void updateTxtStatus(String value) {
    _txtStatus = value;
    _charCountStatus = value.length;
    notifyListeners();
  }

  // Methods to update skills
  void updateTxtSkills(String value) {
    _txtSkills = value;
    _charCountSkills = value.length;
    notifyListeners();
  }

  final ImagePicker _imagePicker = ImagePicker();

  // Variable for the selected image
  XFile? _selectedImage;
  XFile? _selectedBackgroundImage;

  // Getter for the selected image
  XFile? get selectedImage => _selectedImage;

  XFile? get selectedBackgroundImage => _selectedBackgroundImage;

  bool isProfileImageSelected = false;
  bool isBackgroundImageSelected = false;

  // Pick profile image from camera
  Future<void> pickProfileImageFromCamera() async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        _selectedImage = pickedFile;
        isProfileImageSelected = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error picking profile image from camera: $e");
    }
  }

  // Pick background image from camera
  Future<void> pickBackgroundImageFromCamera() async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        _selectedBackgroundImage = pickedFile;
        isBackgroundImageSelected = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error picking background image from camera: $e");
    }
  }

  // Pick profile image from gallery
  Future<void> pickProfileImageFromGallery() async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _selectedImage = pickedFile;
        isProfileImageSelected = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error picking profile image from gallery: $e");
    }
  }

  // Pick background image from gallery
  Future<void> pickBackgroundImageFromGallery() async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _selectedBackgroundImage = pickedFile;
        isBackgroundImageSelected = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error picking background image from gallery: $e");
    }
  }

  // Reset profile image selection
  void resetProfileImage() {
    _selectedImage = null;
    isProfileImageSelected = false;
    notifyListeners();
  }

  // Reset background image selection
  void resetBackgroundImage() {
    _selectedBackgroundImage = null;
    isBackgroundImageSelected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _selectedImage;
    // TODO: implement dispose
    super.dispose();
  }
}
