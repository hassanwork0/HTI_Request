import 'package:flutter/material.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/widgets/home/builders.dart';

Widget buildYearlyTop5Cards(List<StudentModel> students, Localization lang , BuildContext context) {
  return Column(
    children: [
      buildRankedListCard(
        title: lang.TOP5_2021,
        students: students,
        context: context,
        lang: lang,
        year: '2021'
      ),
      buildRankedListCard(
        title: lang.TOP5_2022,
        students: students,
        context: context,
        lang: lang,
        year: '2022'
      ),
      buildRankedListCard(
        title: lang.TOP5_2023,
        students: students,
        context: context,
        lang: lang,
        year: '2023'
      ),
    ],
  );
}