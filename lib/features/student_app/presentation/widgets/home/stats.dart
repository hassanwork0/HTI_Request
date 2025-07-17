
  import 'package:flutter/material.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';

Widget trailing(double gpa) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: getGpaColor(gpa),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        gpa.toStringAsFixed(2),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color getGpaColor(double gpa) {
    if (gpa >= 3.5) return Colors.green;
    if (gpa >= 2.5) return Colors.blue;
    if (gpa >= 1.5) return Colors.orange;
    return Colors.red;
  }

  Color getRankColor(int rank) {
    if (rank == 1) return Colors.amber[700]!;
    if (rank == 2) return Colors.grey[600]!;
    if (rank == 3) return Colors.brown[400]!;
    return Colors.blue[400]!;
  }


extension StudentListExtensions on List<StudentModel> {
  List<StudentModel> sorted(int Function(StudentModel, StudentModel) compare) {
    return List<StudentModel>.from(this)..sort(compare);
  }
}