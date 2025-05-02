class NewsTypeModel {
  List<Data>? data;
  bool? status;

  NewsTypeModel({this.data, this.status});

  NewsTypeModel.fromJson(Map<String, dynamic> json) {
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
  String? nameType;
  String? image;
  bool? statusShow;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.nameType,
      this.image,
      this.statusShow,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameType = json['name_type'];
    image = json['image'];
    statusShow = json['status_show'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_type'] = this.nameType;
    data['image'] = this.image;
    data['status_show'] = this.statusShow;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
