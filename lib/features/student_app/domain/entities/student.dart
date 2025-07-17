import 'package:tables/data/departments/department.dart';
import 'package:tables/features/morshed_app/data/models/morshed_model.dart';
import 'package:tables/features/student_app/data/models/course_model.dart';

class Student {
  final int id;
  double units;
  final String name;
  double gpa;
  MorshedModel morshedDr;
  MorshedModel morshedEng;
  final Department department;
  List<CourseModel> coursesFinished;
  List<CourseModel> currentCourses;
  List<CourseModel> faildCourses;

  Student({
    required this.id,
    required this.name,
    required this.gpa,
    required this.units,
    required this.department,
    required this.morshedDr,
    required this.morshedEng,
    this.coursesFinished = const [],
    this.currentCourses = const [],
    this.faildCourses = const[],
  });

  @override
  String toString() {
    return 'Student{id: $id, units: $units, name: $name, gpa: $gpa, morshedDr: $morshedDr, morshedEng: $morshedEng, departiment: $department, coursesFinsihed: $coursesFinished, currentCourses: $currentCourses}';
  }
}

