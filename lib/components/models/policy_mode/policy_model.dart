class PolicyModel {
  List<Data>? data;
  bool? status;

  PolicyModel({this.data, this.status});

  PolicyModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
  }

  get isNotEmpty => null;

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
  String? username;
  int? policyTypeId;
  String? typeName;
  String? policyName;
  String? policyFile;
  bool? statusShow;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.userId,
      this.username,
      this.policyTypeId,
      this.typeName,
      this.policyName,
      this.policyFile,
      this.statusShow,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    username = json['username'];
    policyTypeId = json['policy_type_id'];
    typeName = json['type_name'];
    policyName = json['policy_name'];
    policyFile = json['policy_file'];
    statusShow = json['status_show'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['policy_type_id'] = this.policyTypeId;
    data['type_name'] = this.typeName;
    data['policy_name'] = this.policyName;
    data['policy_file'] = this.policyFile;
    data['status_show'] = this.statusShow;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
