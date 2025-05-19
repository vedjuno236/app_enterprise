import 'package:enterprise/components/models/notification_model/notiifcation_user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationUserProvider with ChangeNotifier {
  NotificationUserModel? _notificationUserModel;
  NotificationUserModel? get getNotificationUserModel => _notificationUserModel;
  Future setNotificationUserModel({value}) async {
    _notificationUserModel = NotificationUserModel.fromJson(value);
    notifyListeners();
  }
}

final stateNotifitionUserProvider =
    ChangeNotifierProvider<NotificationUserProvider>((ref) {
  return NotificationUserProvider();
});
