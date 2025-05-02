class LeaveTypeModel {
  List<Data>? data;
  bool? status;

  LeaveTypeModel({this.data, this.status});

  LeaveTypeModel.fromJson(Map<String, dynamic> json) {
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
  String? typeName;
  String? keyWord;
  String? logo;
  bool? statusShow;
  double? total;  
  double? used;   

  Data({
    this.id,
    this.typeName,
    this.keyWord,
    this.logo,
    this.statusShow,
    this.total,
    this.used
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeName = json['type_name'];
    keyWord = json['key_word'];
    logo = json['logo'];
    statusShow = json['status_show'];
    
    
    total = json['total']?.toDouble(); 
    used = json['used']?.toDouble();   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type_name'] = this.typeName;
    data['key_word'] = this.keyWord;
    data['logo'] = this.logo;
    data['status_show'] = this.statusShow;
    data['total'] = this.total;
    data['used'] = this.used;
    return data;
  }
}
