class OverviewAttendanceMonthModel {
  Data? data;
  bool? status;

  OverviewAttendanceMonthModel({this.data, this.status});

  OverviewAttendanceMonthModel.fromJson(Map<String, dynamic> json) {
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
  int? totalPages;
  int? perPage;
  int? currentPage;
  List<Items>? items;

  Data({this.totalPages, this.perPage, this.currentPage, this.items});

  Data.fromJson(Map<String, dynamic> json) {
    totalPages = json['total_pages'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_pages'] = this.totalPages;
    data['per_page'] = this.perPage;
    data['current_page'] = this.currentPage;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? userId;
  String? profile;
  String? username;
  String? department;
  int? presentDays;
  int? absentDays;
  int? halfDays;
  double? totalDays;
  int? totalLate;
  List<Attendance>? attendance;

  Items(
      {this.userId,
      this.profile,
      this.username,
      this.department,
      this.presentDays,
      this.absentDays,
      this.halfDays,
      this.totalDays,
      this.totalLate,
      this.attendance});

  Items.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    profile = json['profile'];
    username = json['username'];
    department = json['department'];
    presentDays = json['present_days'];
    absentDays = json['absent_days'];
    halfDays = json['half_days'];
    // Fix for the type 'int' is not a subtype of type 'double?' error
    totalDays = json['total_days'] != null ? (json['total_days'] is int ? (json['total_days'] as int).toDouble() : json['total_days']) : null;
    totalLate = json['total_late'];
    if (json['attendance'] != null) {
      attendance = <Attendance>[];
      json['attendance'].forEach((v) {
        attendance!.add(new Attendance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['profile'] = this.profile;
    data['username'] = this.username;
    data['department'] = this.department;
    data['present_days'] = this.presentDays;
    data['absent_days'] = this.absentDays;
    data['half_days'] = this.halfDays;
    data['total_days'] = this.totalDays;
    data['total_late'] = this.totalLate;
    if (this.attendance != null) {
      data['attendance'] = this.attendance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attendance {
  String? date;
  String? type;
  double? latitude;
  double? longitude;
  String? title;
  String? image;
  String? clockIn;
  String? clockOut;
  String? totalHours;
  bool? statusLate;
  bool? status;
  String? keyWordLate;
  int? leaveTypeId;
  String? typeName;
  String? logo;
  String? startDate;
  String? endDate;
  double? totalDays;
  String? reason;
  String? document;
  String? leaveStatus;
  dynamic approvedBy;
  double? dayValue;

  Attendance({
    this.date,
    this.type,
    this.latitude,
    this.longitude,
    this.title,
    this.image,
    this.clockIn,
    this.clockOut,
    this.totalHours,
    this.statusLate,
    this.status,
    this.keyWordLate,
    this.leaveTypeId,
    this.typeName,
    this.logo,
    this.startDate,
    this.endDate,
    this.totalDays,
    this.reason,
    this.document,
    this.leaveStatus,
    this.approvedBy,
    this.dayValue,
  });

  Attendance.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    type = json['type'];
    latitude = json['latitude'] != null ? (json['latitude'] is num ? (json['latitude'] as num).toDouble() : json['latitude']) : null;
    longitude = json['longitude'] != null ? (json['longitude'] is num ? (json['longitude'] as num).toDouble() : json['longitude']) : null;
    title = json['title'];
    image = json['image'];
    clockIn = json['clock_in'];
    clockOut = json['clock_out'];
    totalHours = json['total_hours'];
    statusLate = json['status_late'];
    status = json['status'];
    keyWordLate = json['key_word_late'];
    leaveTypeId = json['leave_type_id'];
    typeName = json['type_name'];
    logo = json['logo'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    totalDays = json['total_days'] != null ? (json['total_days'] is int ? (json['total_days'] as int).toDouble() : json['total_days']) : null;
    reason = json['reason'];
    document = json['document'];
    leaveStatus = json['leave_status'];
    approvedBy = json['approved_by'];
    dayValue = json['day_value'] != null ? (json['day_value'] is int ? (json['day_value'] as int).toDouble() : json['day_value']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = date;
    data['type'] = type;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['title'] = title;
    data['image'] = image;
    data['clock_in'] = clockIn;
    data['clock_out'] = clockOut;
    data['total_hours'] = totalHours;
    data['status_late'] = statusLate;
    data['status'] = status;
    data['key_word_late'] = keyWordLate;
    data['leave_type_id'] = leaveTypeId;
    data['type_name'] = typeName;
    data['logo'] = logo;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['total_days'] = totalDays;
    data['reason'] = reason;
    data['document'] = document;
    data['leave_status'] = leaveStatus;
    data['approved_by'] = approvedBy;
    data['day_value'] = dayValue;
    return data;
  }
}