import '../entities/student.dart';
import '../repositories/student_repo.dart';

class VerifyRu {
  final StudentRepository sr; 
  const VerifyRu({required this.sr});

  Future<Student?> call(){
    return sr.verifyRememberedUser();
  }
}