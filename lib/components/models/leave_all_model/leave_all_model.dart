class AllLeaveModel {
  List<Data>? data;
  bool? status;

  AllLeaveModel({this.data, this.status});

  AllLeaveModel.fromJson(Map<String, dynamic> json) {
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
  double? total;
  double? used;
  double? unUsed;
  List<ApprovedBy>? approvedBy;
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
      this.unUsed,
      this.approvedBy,
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

    total = json['total'] is num ? (json['total'] as num).toDouble() : 0.0;
    used = json['used'] is num ? (json['used'] as num).toDouble() : 0.0;
    unUsed = json['un_used'] is num ? (json['un_used'] as num).toDouble() : 0.0;

    if (json['approved_by'] != null) {
      approvedBy = <ApprovedBy>[];
      json['approved_by'].forEach((v) {
        approvedBy!.add(new ApprovedBy.fromJson(v));
      });
    }
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
    data['un_used'] = this.unUsed;
    if (this.approvedBy != null) {
      data['approved_by'] = this.approvedBy!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ApprovedBy {
  int? id;
  String? username;
  String? profile;
  String? departmentName;
  String? positionName;
  String? status;
  String? comment;

  ApprovedBy(
      {this.id,
      this.username,
      this.profile,
      this.departmentName,
      this.positionName,
      this.status,
      this.comment});

  ApprovedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    profile = json['profile'];
    departmentName = json['department_name'];
    positionName = json['position_name'];
    status = json['status'];
    comment = json['comment'];
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
    return data;
  }
}
