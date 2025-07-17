
// * * class FeatureRepostoryImp extends FeatureRepository {
  
  //!Feature Remote
  // * *FeatureRemoteData crd = FeatureRemoteData();
  
  //!Feature Functions
  // @override

import 'package:tables/data/departments/department.dart';
import 'package:tables/features/student_app/data/models/course_model.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';

import '../sources/student_remote.dart';
import '../../domain/repositories/course_repo.dart';
import '../../domain/repositories/student_repo.dart';

class StudentImpt implements StudentRepository , CourseRepository{
  final StudentRemoteData str = StudentRemoteData();

  @override
  Map<Map<String ,int>, List<CourseModel>> getAllCourses(Department department) {
    return str.getAllCourses(department);
  }

  @override
  Future<List<StudentModel>> getAllStudents() {
    return str.getAllStudents();
  }

  @override
  Future<StudentModel> getStudentById({required int id}) {
    return str.getStudentById(id:id);
  }

  @override
  Future<Map<String,List<CourseModel>>> getStudentCourses(int studentId) {
    return str.getStudentCourses(studentId);
  }

    @override
      Future<StudentModel?> verifyRememberedUser() async {
      return str.verifyRememberedUser();
    }

}