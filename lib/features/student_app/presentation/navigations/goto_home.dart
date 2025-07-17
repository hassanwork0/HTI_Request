import 'package:flutter/material.dart';
import 'package:tables/core/routes/names.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';

gotoHome(BuildContext context , List<StudentModel> students , StudentModel currentStudent , bool isLoggedIn){
              Navigator.pushReplacementNamed(
              context,
              RoutesName.studentHome,
              arguments: {
                'students': students,
                'isLoggedIn': isLoggedIn,
                'currentStudent': currentStudent,
              },
            );
}