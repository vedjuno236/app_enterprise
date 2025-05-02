import 'package:enterprise/components/models/analytic_model/leave_type_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../logger/logger.dart';

final stateLeaveProvider = ChangeNotifierProvider<LeaveProvider>((ref) {
  return LeaveProvider();
});

class LeaveProvider with ChangeNotifier {
  /// type leave

  String? _selectedLeaveType;
  bool _isDropdownOpen = false;

  String? get selectedLeaveType => _selectedLeaveType;

  bool get isDropdownOpen => _isDropdownOpen;

  set isDropdownOpen(bool dropdownOpen) {
    _isDropdownOpen = dropdownOpen;
    notifyListeners();
  }

  set selectedLeaveType(String? typeLeave) {
    _selectedLeaveType = typeLeave;
    notifyListeners();
  }

  bool shouldShowCustomTextField(String keyword) {
    return _selectedLeaveType == keyword;
  }

  ///
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  /// PAI
  LeaveTypeModel? _leaveTypeModel;

  LeaveTypeModel? get getLeaveTypeModel => _leaveTypeModel;

  Future setLeaveTypeModels({value}) async {
    _leaveTypeModel = LeaveTypeModel.fromJson(value);
    notifyListeners();
  }

  /// DateTime
  DateTime? _selectedDateStart = DateTime.now();

  DateTime? _selectedDateEnd;

  DateTime? get selectedDateStart => _selectedDateStart;

  set selectedDateStart(DateTime? date) {
    _selectedDateStart = date;
    notifyListeners();
  }

  DateTime? get selectedDateEnd => _selectedDateEnd;

  // Setter for end date
  set selectedDateEnd(DateTime? date) {
    _selectedDateEnd = date;
    notifyListeners();
  }

  /// Time
  DateTime? _selectedTimeStart;
  DateTime? _selectedTimeEnd;

  DateTime? get selectedTimeStart => _selectedTimeStart;

  set selectedTimeStart(DateTime? date) {
    _selectedTimeStart = date;
    notifyListeners();
  }

  DateTime? get selectedTimeEnd => _selectedTimeEnd;

  // Setter for end date
  set selectedTimeEnd(DateTime? date) {
    _selectedTimeEnd = date;
    notifyListeners();
  }

  final ImagePicker _imagePicker = ImagePicker();

  // Variable for the selected image
  XFile? _selectedImage;

  // Getter for the selected image
  XFile? get selectedImage => _selectedImage;

  /// check box
  String? _setSelectedRadioOption;

  String? get selectedRadioOption => _setSelectedRadioOption;

  void setSelectedRadioOption(String value) {
    _setSelectedRadioOption = value;
    notifyListeners();
  }

  // Pick an image from the gallery
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
  Future<void> pickImageFromCamera() async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        _selectedImage = pickedFile;
        notifyListeners();
      }
    } catch (e) {
      logger.d("Error picking image from camera: $e");
    }
  }

  // Clear the selected image
  void clearImage() {
    _selectedImage = null;
    notifyListeners();
  }

  void resetForm() {
    _selectedDateStart = null;
    _selectedDateEnd = null;
    _selectedImage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _selectedImage;
    // TODO: implement dispose
    super.dispose();
  }
}
