import 'package:flutter/material.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';

void showAllStudentsDialog(
  BuildContext context,
  List<StudentModel> students,
  String year,
  Localization lang,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('${lang.ALL_STUDENTS} ($year)'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[700],
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(student.name),
                subtitle: Text('ID: ${student.id} • GPA: ${student.gpa}'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(lang.CLOSE),
          ),
        ],
      );
    },
  );
}