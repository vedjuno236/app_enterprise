class ConditionSettingModel {
  Data? data;
  bool? status;

  ConditionSettingModel({this.data, this.status});

  ConditionSettingModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Data {
  double? officeLat;
  double? officeLong;
  double? radius;
  String? workStartTime;
  String? breakStartTime;
  String? breakEndTime;
  String? workEndTime;

  Data(
      {this.officeLat,
      this.officeLong,
      this.radius,
      this.workStartTime,
      this.breakStartTime,
      this.breakEndTime,
      this.workEndTime});

  Data.fromJson(Map<String, dynamic> json) {
    officeLat = (json['office_lat'] as num?)?.toDouble();
    officeLong = (json['office_long'] as num?)?.toDouble();
    radius = (json['radius'] as num?)?.toDouble();
    workStartTime = json['work_start_time'];
    breakStartTime = json['break_start_time'];
    breakEndTime = json['break_end_time'];
    workEndTime = json['work_end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['office_lat'] = this.officeLat;
    data['office_long'] = this.officeLong;
    data['radius'] = this.radius;
    data['work_start_time'] = this.workStartTime;
    data['break_start_time'] = this.breakStartTime;
    data['break_end_time'] = this.breakEndTime;
    data['work_end_time'] = this.workEndTime;
    return data;
  }
}
