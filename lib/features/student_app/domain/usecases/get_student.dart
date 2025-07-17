import '../entities/student.dart';
import '../repositories/student_repo.dart';

class GetStudent {
  final StudentRepository sr; 
  const GetStudent({required this.sr});

  Future<Student> call(int id){
    return sr.getStudentById(id: id);
  }
}