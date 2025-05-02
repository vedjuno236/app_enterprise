class allLeaveHistoryModel {
  List<Data>? data;
  bool? status;

  allLeaveHistoryModel({this.data, this.status});

  allLeaveHistoryModel.fromJson(Map<String, dynamic> json) {
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
  int? leaveTypeId;
  String? typeName;
  String? keyWord;
  String? logo;
  String? startDate;
  String? endDate;
  int? totalDays;
  String? reason;
  String? document;
  String? status;
  List<ApprovedBy>? approvedBy;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.userId,
      this.profile,
      this.username,
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
      this.approvedBy,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    profile = json['profile'];
    username = json['username'];
    leaveTypeId = json['leave_type_id'];
    typeName = json['type_name'];
    keyWord = json['key_word'];
    logo = json['logo'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    totalDays = json['total_days'];
    reason = json['reason'];
    document = json['document'];
    status = json['status'];
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
