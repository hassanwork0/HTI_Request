import 'package:tables/data/departments/electrical.dart';
import 'package:tables/features/student_app/data/models/course_model.dart';

abstract class Department {
  String get name;
  String get code;
  Map<String, dynamic> toJson();
  Map<Map<String, int>, List<CourseModel>> get allCoursesMap => {};
  List<CourseModel> get allCoursesList => [];
  List< Map<String,List<CourseModel>> > get departmentTree => [];


  factory Department.fromJson(dynamic type) {
    final name = type is Map<String , dynamic> ? type['name'] : type;

    if(name == Electrical().toString()){
      return Electrical();
    }
    print('getDepartment : Did not find the department');
    return Electrical();

   }

   @override
  String toString() {
    return name;
  }

}