  import 'package:flutter/material.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/navigations/goto_sp.dart';
import 'package:tables/features/student_app/presentation/widgets/home/stats.dart';

Widget buildStudentCard(StudentModel student , BuildContext context , Localization lang) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(
            student.id.toString().substring(student.id.toString().length - 3),
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          student.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'ID: ${student.id}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: trailing(student.gpa),
        onTap: () {
          gotoStudentProfile(context, student , false , lang);
        },
      ),
    );
  }
