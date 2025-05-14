
class SQLiteModel {
  final int? id;
  final int? idUser;
  final String? type; // Add type
  final double? latitude;
  final double? longitude;
  final String? imagePath;
  final String? title;
  final String createdAt;
  final bool isSynced;

  SQLiteModel({
    this.id,
    this.idUser,
    this.type,
    this.latitude,
    this.longitude,
    this.imagePath,
    this.title,
    required this.createdAt,
    required this.isSynced,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUser': idUser,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'imagePath': imagePath,
      'title': title,
      'createdAt': createdAt,
      'isSynced': isSynced ? 1:0,
    };
  }

  factory SQLiteModel.fromMap(Map<String, dynamic> map) {
    return SQLiteModel(
      id: map['id'],
      idUser: map['idUser'],
      type: map['type'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      imagePath: map['imagePath'],
      title: map['title'],
      createdAt: map['createdAt'],
      isSynced: map['isSynced'] ==1,
    );
  }
}
