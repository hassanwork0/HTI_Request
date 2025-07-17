
  import 'package:flutter/material.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/widgets/home/top_10.dart';
import 'package:tables/features/student_app/presentation/widgets/home/top_5.dart';
import 'package:tables/features/student_app/presentation/widgets/home/top_5p.dart';
import 'package:tables/features/student_app/presentation/widgets/home/welcome.dart';
import 'package:tables/features/student_app/presentation/widgets/search_bar.dart';

Widget buildHomeContent(BuildContext context, Localization lang , List<StudentModel> students ,TextEditingController searchController, bool showSearchResults,List<StudentModel> filteredStudents) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: buildHomeSearchBar(context , searchController, showSearchResults, lang, filteredStudents, students),
          ),
          buildWelcomeMessage(lang),
          buildTop10GpaCard(students, lang , context),
          buildPickTop5Card(students, lang, context),
          buildYearlyTop5Cards(students, lang , context),
        ],
      ),
    );
  }