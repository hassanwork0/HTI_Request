
// * * abstract class FeatureRepository {
//! abstract Functions
import '../entities/student.dart';

abstract class StudentRepository{
  Future<List<Student>> getAllStudents();
  Future<Student> getStudentById({required int id});
  Future<Student?> verifyRememberedUser();
  
}