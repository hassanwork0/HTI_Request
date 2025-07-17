
  import 'package:flutter/material.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/widgets/home/builders.dart';

Widget buildTop10GpaCard(List<StudentModel> students , Localization lang , BuildContext context) {

    return buildRankedListCard(
      title: lang.TOP10,
      students: students,
        context: context,
        lang: lang,
        year: ''
    );
  }
