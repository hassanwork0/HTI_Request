import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tables/data/departments/department.dart';
import 'dart:convert';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/data/models/course_model.dart';
import '../../domain/repositories/course_repo.dart';
import '../../domain/repositories/student_repo.dart';

class StudentRemoteData implements StudentRepository, CourseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<StudentModel>> getAllStudents() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('students').get();
      return snapshot.docs.map((doc) {
        return StudentModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching students: $e');
      return [];
    }
  }

  @override
  Future<StudentModel> getStudentById({required int id}) async {
    try {
      final snapshot = await _firestore
          .collection('students')
          .where('id', isEqualTo: id)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception('Student not found');
      }

      return _studentFromFirestore(snapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to fetch student: $e');
    }
  }

  @override
  Future<StudentModel?> verifyRememberedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final studentJson = prefs.getString('currentStudent');
      final rememberedPassword = prefs.getString('rememberedStudentPassword');

      if (studentJson == null || rememberedPassword == null) {
        return null; // No remembered user
      }

      final studentMap = jsonDecode(studentJson) as Map<String, dynamic>;
      final currentStudent = StudentModel.fromJson(studentMap);

      // Verify student exists and password matches
      final studentDoc = await _firestore
          .collection('students')
          .doc(currentStudent.id.toString())
          .get();

      if (!studentDoc.exists) {
        return null; // Student not found
      }

      final storedPassword = studentDoc.data()?['password'];
      if (storedPassword == rememberedPassword) {
        return currentStudent; // Valid remembered user
      }
      return null; // Password mismatch
    } catch (e) {
      throw Exception('Error verifying remembered user: $e');
    }
  }

  @override
  Future<Map<String, List<CourseModel>>> getStudentCourses(int studentId) async {
    try {
      final student = await getStudentById(id:studentId);
      return {
        "currentCourses": student.currentCourses,
        "coursesFinished": student.coursesFinished,
        "faildCourses": student.faildCourses
      };
    } catch (e) {
      throw Exception('Failed to fetch student courses: $e');
    }
  }

  StudentModel _studentFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return StudentModel.fromJson(data);
  }

  @override
  Map<Map<String ,int>, List<CourseModel>> getAllCourses(Department department) {
    return department.allCoursesMap;
  }

}