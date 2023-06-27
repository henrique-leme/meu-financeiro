import 'dart:convert';
import 'package:uuid/uuid.dart';

class AnalysisModel {
  AnalysisModel({
    required this.path,
    required this.description,
    required this.value,
    this.id,
  });

  final String description;
  final String path;
  final double value;
  final String? id;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'path': path,
      'value': value,
      'id': id ?? const Uuid().v4(),
    };
  }

  factory AnalysisModel.fromMap(Map<String, dynamic> map) {
    return AnalysisModel(
      description: map['description'] as String,
      path: map['path'] as String,
      value: double.tryParse(map['value'].toString()) ?? 0,
      id: map['id'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory AnalysisModel.fromJson(String source) =>
      AnalysisModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant AnalysisModel other) {
    if (identical(this, other)) return true;

    return other.description == description &&
        other.path == path &&
        other.value == value &&
        other.id == id;
  }

  @override
  int get hashCode {
    return description.hashCode ^ path.hashCode ^ value.hashCode ^ id.hashCode;
  }
}
