class FunctionsMenuModel {
  List<Data>? data;
  bool? status;

  FunctionsMenuModel({this.data, this.status});

  FunctionsMenuModel.fromJson(Map<String, dynamic> json) {
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
  String? keyWord;
  String? menuName;
  String? icon;
  bool? statusShow;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.keyWord,
      this.menuName,
      this.icon,
      this.statusShow,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    keyWord = json['key_word'];
    menuName = json['menu_name'];
    icon = json['icon'];
    statusShow = json['status_show'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['key_word'] = this.keyWord;
    data['menu_name'] = this.menuName;
    data['icon'] = this.icon;
    data['status_show'] = this.statusShow;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
