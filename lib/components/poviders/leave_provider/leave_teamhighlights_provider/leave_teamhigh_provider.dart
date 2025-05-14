
import 'package:enterprise/components/models/notification_model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final teamHighlightsProvider =
    ChangeNotifierProvider<TeamHighlightsNotifier>((ref) {
  return TeamHighlightsNotifier();
});

class TeamHighlightsNotifier with ChangeNotifier {
  NotificationModel? _notificationModel;
  NotificationModel? get getNotificationModel => _notificationModel;

  // Methods
  Future<void> setNotificationModel({required dynamic value}) async {
    _notificationModel = NotificationModel.fromJson(value);
    notifyListeners();
  }
}

