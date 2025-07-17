import 'package:flutter/material.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/screens/gpa_test.dart';

gotoGpa(BuildContext context , StudentModel student){
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GpaTestScreen(student: student),
            ),
          );
}