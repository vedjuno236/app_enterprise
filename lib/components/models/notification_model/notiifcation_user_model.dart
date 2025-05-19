class NotificationUserModel {
  List<Data>? data;
  bool? status;

  NotificationUserModel({this.data, this.status});

  NotificationUserModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int? id;
  String? username;
  String? profile;
  String? departmentName;
  String? positionName;
  String? status;
  String? comment;
  String? startDate;
  String? endDate;
  int? leaveTypeId;
  String? typeName;
  String? keyWord;
  String? logo;
  double? totalDays;
  String? createdAt;

  Data(
      {this.id,
      this.username,
      this.profile,
      this.departmentName,
      this.positionName,
      this.status,
      this.comment,
      this.startDate,
      this.endDate,
      this.leaveTypeId,
      this.typeName,
      this.keyWord,
      this.logo,
      this.totalDays,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    profile = json['profile'];
    departmentName = json['department_name'];
    positionName = json['position_name'];
    status = json['status'];
    comment = json['comment'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    leaveTypeId = json['leave_type_id'];
    typeName = json['type_name'];
    keyWord = json['key_word'];
    logo = json['logo'];
    totalDays = json['total_days'] is num
        ? (json['total_days'] as num).toDouble()
        : 0.0;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['profile'] = this.profile;
    data['department_name'] = this.departmentName;
    data['position_name'] = this.positionName;
    data['status'] = this.status;
    data['comment'] = this.comment;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['leave_type_id'] = this.leaveTypeId;
    data['type_name'] = this.typeName;
    data['key_word'] = this.keyWord;
    data['logo'] = this.logo;
    data['total_days'] = this.totalDays;
    data['created_at'] = this.createdAt;
    return data;
  }
}
