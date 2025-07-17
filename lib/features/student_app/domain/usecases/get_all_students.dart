import '../entities/student.dart';
import '../repositories/student_repo.dart';

class GetAllStudents {
  final StudentRepository sr; 
  const GetAllStudents({required this.sr});

  Future<List<Student>> call(){
    return sr.getAllStudents();
  }
}