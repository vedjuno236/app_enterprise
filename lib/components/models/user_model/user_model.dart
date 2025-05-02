class UserModel {
  Data? data;
  bool? status;

  UserModel({this.data, this.status});

  UserModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? username;
  bool? accessStatus;
  String? phone;
  String? departmentName;
  String? positionName;
  String? profile;
  String? firstName;
  String? lastName;
  String? email;
  String? birthday;
  String? status;
  String? sex;
  String? nationality;
  String? village;
  String? district;
  String? province;
  int? employeeCode;
  String? workStatus;
  String? workStartDate;
  String? employeeStartDate;
  String? workAddress;
  Role? role;
  String? createdAt;

  Data(
      {this.id,
      this.username,
      this.accessStatus,
      this.phone,
      this.departmentName,
      this.positionName,
      this.profile,
      this.firstName,
      this.lastName,
      this.email,
      this.birthday,
      this.status,
      this.sex,
      this.nationality,
      this.village,
      this.district,
      this.province,
      this.employeeCode,
      this.workStatus,
      this.workStartDate,
      this.employeeStartDate,
      this.workAddress,
      this.role,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    accessStatus = json['access_status'];
    phone = json['phone'];
    departmentName = json['department_name'];
    positionName = json['position_name'];
    profile = json['profile'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    birthday = json['birthday'];
    status = json['status'];
    sex = json['sex'];
    nationality = json['nationality'];
    village = json['village'];
    district = json['district'];
    province = json['province'];
    employeeCode = json['employee_code'];
    workStatus = json['work_status'];
    workStartDate = json['work_start_date'];
    employeeStartDate = json['employee_start_date'];
    workAddress = json['work_address'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['access_status'] = this.accessStatus;
    data['phone'] = this.phone;
    data['department_name'] = this.departmentName;
    data['position_name'] = this.positionName;
    data['profile'] = this.profile;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['birthday'] = this.birthday;
    data['status'] = this.status;
    data['sex'] = this.sex;
    data['nationality'] = this.nationality;
    data['village'] = this.village;
    data['district'] = this.district;
    data['province'] = this.province;
    data['employee_code'] = this.employeeCode;
    data['work_status'] = this.workStatus;
    data['work_start_date'] = this.workStartDate;
    data['employee_start_date'] = this.employeeStartDate;
    data['work_address'] = this.workAddress;
    if (this.role != null) {
      data['role'] = this.role!.toJson();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Role {
  String? name;
  List<String>? permission;

  Role({this.name, this.permission});

  Role.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    permission = json['permission'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['permission'] = this.permission;
    return data;
  }
}
