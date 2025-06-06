class CheckBooleanInOutModel {
  Data? data;
  bool? status;

  CheckBooleanInOutModel({this.data, this.status});

  CheckBooleanInOutModel.fromJson(Map<String, dynamic> json) {
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
  String? date;
  String? typeClock;

  Data({this.id, this.date, this.typeClock});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    typeClock = json['type_clock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['type_clock'] = this.typeClock;
    return data;
  }
}
