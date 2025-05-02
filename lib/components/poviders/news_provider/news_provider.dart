import 'package:enterprise/components/models/news_model/news_pagination_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/news_model/news_model.dart';
import '../../models/news_model/news_type_model.dart';

final stateNewsProvider = ChangeNotifierProvider<NewsProvider>((ref) {
  return NewsProvider();
});

class NewsProvider with ChangeNotifier {
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  int? _dropdownValue;

  int? get dropdown => _dropdownValue;

  set dropdown(dropdown) {
    _dropdownValue = dropdown;
    notifyListeners();
  }

  NewsTypeModel? _newsTypeModel;
  NewsModel? _newsModel;
  NewsPaginationModel? _newsPaginationModel;

  NewsPaginationModel? get getNewsPaginationModel => _newsPaginationModel;

  NewsTypeModel? get getNewsTypeModel => _newsTypeModel;

  NewsModel? get getNewsModel => _newsModel;

  Future setNewsTypeModels({value}) async {
    _newsTypeModel = NewsTypeModel.fromJson(value);
    notifyListeners();
  }

  Future setNewsPaginationModel({value}) async {
    _newsPaginationModel = NewsPaginationModel.fromJson(value);
    notifyListeners();
  }

  Future setNewsModels({value}) async {
    _newsModel = NewsModel.fromJson(value);

    notifyListeners();
  }

  int? _selectedIndex;

  int? get selectedIndex => _selectedIndex;

  set selectedIndex(int? value) {
    _selectedIndex = value;
    notifyListeners();
  }

  final ImagePicker _imagePicker = ImagePicker();

  // Variable for the selected image
  bool isBackgroundImageSelected = false;

  XFile? _selectedBackgroundImage;

  XFile? get selectedBackgroundImage => _selectedBackgroundImage;

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

  void clearForm() {
    _selectedBackgroundImage = null;
    dropdown = null;
    notifyListeners();
  }
}
