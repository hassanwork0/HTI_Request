import 'package:flutter/material.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/core/routes/names.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';

gotoStudentProfile(BuildContext context , StudentModel student , bool myProfile , Localization lang){
  Navigator.pushNamed(
            context,
            RoutesName.studentProfile,
            arguments: {
              "student": student,
              "myProfile": myProfile,
              "lang":lang
            },
          );
}