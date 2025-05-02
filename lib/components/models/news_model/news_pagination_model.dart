class NewsPaginationModel {
  Data? data;
  bool? status;

  NewsPaginationModel({this.data, this.status});

  NewsPaginationModel.fromJson(Map<String, dynamic> json) {
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
  List<ItemsNews>? items;

  Data({this.totalPages, this.perPage, this.currentPage, this.items});

  Data.fromJson(Map<String, dynamic> json) {
    totalPages = json['total_pages'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    if (json['items'] != null) {
      items = <ItemsNews>[];
      json['items'].forEach((v) {
        items!.add(new ItemsNews.fromJson(v));
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

class ItemsNews {
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

  ItemsNews(
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

  ItemsNews.fromJson(Map<String, dynamic> json) {
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
