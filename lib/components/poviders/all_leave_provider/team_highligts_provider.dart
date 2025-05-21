import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/models/leave_all_model/leave_all_model.dart';
import 'package:enterprise/components/utils/date_format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stateTeamHighligtsProvider = ChangeNotifierProvider<TeamHighligtsLeaveProvider>((ref) {
  return TeamHighligtsLeaveProvider();
});

class TeamHighligtsLeaveProvider with ChangeNotifier {
  AllLeaveModel? _teamHighligtsModel;
  AllLeaveModel? get getTeamHighligtsModelLeaveModel => _teamHighligtsModel;

  Future setteamHighligtsLeaveModel({value}) async {
    _teamHighligtsModel = AllLeaveModel.fromJson(value);
    notifyListeners();
  }

}
