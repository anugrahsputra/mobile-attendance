const String tableAttendances = 'tb_attendance';

class AttendanceFields {
  static final List<String> values = [
    id,
    name,
    latitude,
    longitude,
    createdAt,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String createdAt = 'createdAt';
}

class AttendanceModel {
  final int? id;
  final String name;
  final double latitude;
  final double longtitude;
  final DateTime createdAt;

  AttendanceModel({
    this.id,
    required this.name,
    required this.latitude,
    required this.longtitude,
    required this.createdAt,
  });

  AttendanceModel copy({
    int? id,
    String? name,
    double? latitude,
    double? longtitude,
    DateTime? createdAt,
  }) =>
      AttendanceModel(
        id: id ?? this.id,
        name: name ?? this.name,
        latitude: latitude ?? this.latitude,
        longtitude: longtitude ?? this.longtitude,
        createdAt: createdAt ?? this.createdAt,
      );

  static AttendanceModel fromJson(Map<String, Object?> json) => AttendanceModel(
        id: json[AttendanceFields.id] as int?,
        name: json[AttendanceFields.name] as String,
        latitude: json[AttendanceFields.latitude] as double,
        longtitude: json[AttendanceFields.longitude] as double,
        createdAt: DateTime.parse(json[AttendanceFields.createdAt] as String),
      );

  Map<String, Object?> toJson() => {
        AttendanceFields.id: id,
        AttendanceFields.name: name,
        AttendanceFields.latitude: latitude,
        AttendanceFields.longitude: longtitude,
        AttendanceFields.createdAt: createdAt.toIso8601String(),
      };
}
