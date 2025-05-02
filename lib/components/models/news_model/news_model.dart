class NewsModel {
  List<Data>? data;
  bool? status;

  NewsModel({this.data, this.status});

  NewsModel.fromJson(Map<String, dynamic> json) {
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
  String? username;
  int? newsTypeId;
  String? nameType;
  String? image;
  String? title;
  String? description;
  String? link;
  bool? statusShow;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.userId,
      this.username,
      this.newsTypeId,
      this.nameType,
      this.image,
      this.title,
      this.description,
      this.link,
      this.statusShow,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    username = json['username'];
    newsTypeId = json['news_type_id'];
    nameType = json['name_type'];
    image = json['image'];
    title = json['title'];
    description = json['description'];
    link = json['link'];
    statusShow = json['status_show'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['news_type_id'] = this.newsTypeId;
    data['name_type'] = this.nameType;
    data['image'] = this.image;
    data['title'] = this.title;
    data['description'] = this.description;
    data['link'] = this.link;
    data['status_show'] = this.statusShow;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
