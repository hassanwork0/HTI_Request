import 'package:tables/data/departments/department.dart';

import '../entities/course.dart';

abstract class CourseRepository {
  Map<Map<String ,int>, List<Course>> getAllCourses(Department department);
 Future<Map<String,List<Course>>> getStudentCourses(int studentId);
}