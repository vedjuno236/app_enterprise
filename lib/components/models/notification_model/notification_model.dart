class NotificationModel {
  List<Data>? data;
  bool? status;

  NotificationModel({this.data, this.status});

  NotificationModel.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  String? profile;
  String? username;
  String? departmentName;
  int? leaveTypeId;
  String? typeName;
  String? keyWord;
  String? logo;
  String? startDate;
  String? endDate;
  double? totalDays;
  String? reason;
  String? document;
  String? status;
  int? total;
  int? used;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.userId,
      this.profile,
      this.username,
      this.departmentName,
      this.leaveTypeId,
      this.typeName,
      this.keyWord,
      this.logo,
      this.startDate,
      this.endDate,
      this.totalDays,
      this.reason,
      this.document,
      this.status,
      this.total,
      this.used,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    profile = json['profile'];
    username = json['username'];
    departmentName = json['department_name'];
    leaveTypeId = json['leave_type_id'];
    typeName = json['type_name'];
    keyWord = json['key_word'];
    logo = json['logo'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    totalDays = json['total_days'] is num
        ? (json['total_days'] as num).toDouble()
        : 0.0;

    reason = json['reason'];
    document = json['document'];
    status = json['status'];
    total = json['total'];
    used = json['used'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['profile'] = this.profile;
    data['username'] = this.username;
    data['department_name'] = this.departmentName;
    data['leave_type_id'] = this.leaveTypeId;
    data['type_name'] = this.typeName;
    data['key_word'] = this.keyWord;
    data['logo'] = this.logo;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['total_days'] = this.totalDays;
    data['reason'] = this.reason;
    data['document'] = this.document;
    data['status'] = this.status;
    data['total'] = this.total;
    data['used'] = this.used;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
