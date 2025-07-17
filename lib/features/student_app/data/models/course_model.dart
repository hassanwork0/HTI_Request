import '../../domain/entities/course.dart';

class CourseModel extends Course {
  CourseModel({
   required super.name,
   required super.id,
   required super.units,
   required super.departmentCode,
   super.electiveName,
   });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      name: json['name'],
      id: json['id'],
      units: json['units'],
      departmentCode: json['department'],
      electiveName: json['elective']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'units': units,
      'department': departmentCode,
      'elective': electiveName,
    };
  }
}
