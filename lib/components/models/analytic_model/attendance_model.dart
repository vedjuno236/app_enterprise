class AttendanceModel {
  Data? data;
  bool? status;

  AttendanceModel({this.data, this.status});

  AttendanceModel.fromJson(Map<String, dynamic> json) {
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
  String? date;
  List<AttendanceRecordResponse>? attendanceRecordResponse;

  Items({this.date, this.attendanceRecordResponse});

  Items.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['attendance_record_response'] != null) {
      attendanceRecordResponse = <AttendanceRecordResponse>[];
      json['attendance_record_response'].forEach((v) {
        attendanceRecordResponse!.add(new AttendanceRecordResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.attendanceRecordResponse != null) {
      data['attendance_record_response'] =
          this.attendanceRecordResponse!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttendanceRecordResponse {
  int? id;
  int? userId;
  String? userName;
  String? type;
  double? latitude;  // Changed from int? to double?
  double? longitude; // Changed from int? to double?
  String? title;
  String? image;
  String? date;
  String? typeClock;
  bool? statusLate;
  int? lateMinutes;
  String? totalHours;
  int? oTime;
  bool? status;
  String? createdAt;
  String? updatedAt;

  AttendanceRecordResponse(
      {this.id,
      this.userId,
      this.userName,
      this.type,
      this.latitude,
      this.longitude,
      this.title,
      this.image,
      this.date,
      this.typeClock,
      this.statusLate,
      this.lateMinutes,
      this.totalHours,
      this.oTime,
      this.status,
      this.createdAt,
      this.updatedAt});

  AttendanceRecordResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    type = json['type'];
    latitude = json['latitude'] != null ? (json['latitude'] is num ? (json['latitude'] as num).toDouble() : json['latitude']) : null;
    longitude = json['longitude'] != null ? (json['longitude'] is num ? (json['longitude'] as num).toDouble() : json['longitude']) : null;
    title = json['title'];
    image = json['image'];
    date = json['date'];
    typeClock = json['type_clock'];
    statusLate = json['status_late'];
    lateMinutes = json['late_minutes'];
    totalHours = json['total_hours'];
    oTime = json['o_time'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['type'] = this.type;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['title'] = this.title;
    data['image'] = this.image;
    data['date'] = this.date;
    data['type_clock'] = this.typeClock;
    data['status_late'] = this.statusLate;
    data['late_minutes'] = this.lateMinutes;
    data['total_hours'] = this.totalHours;
    data['o_time'] = this.oTime;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
