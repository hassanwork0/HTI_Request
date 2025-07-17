import 'package:tables/data/departments/department.dart';

import '../entities/course.dart';
import '../repositories/course_repo.dart';

class GetAllCourses {
  final CourseRepository sr; 
  const GetAllCourses({required this.sr});

  Map<Map<String ,int>, List<Course>> call(Department department){
    return sr.getAllCourses(department);
  }
}