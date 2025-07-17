import '../entities/course.dart';
import '../repositories/course_repo.dart';

class GetCourse {
  final CourseRepository sr; 
  const GetCourse({required this.sr});

  Future<Map<String,List<Course>>> call(int id){
    return sr.getStudentCourses(id);
  }
}