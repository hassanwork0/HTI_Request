import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/Bloc/home_bloc.dart';
import 'package:tables/features/student_app/presentation/Bloc/home_event.dart';
import 'package:tables/features/student_app/presentation/widgets/home/student_card.dart';

Widget buildHomeSearchBar(BuildContext context, TextEditingController searchController, bool showSearchResults , Localization lang
,List<StudentModel> filteredStudents , List<StudentModel> students) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: lang.SEARCH,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(bottom: 15),
                hintStyle: const TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(fontSize: 16),
              onTap: () {
              context.read<HomeBloc>().add(ToggleSearch(showSearch: true));
              },
            ),
          ),
          if (showSearchResults)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.blue),
              onPressed: () {

              context.read<HomeBloc>().add(ToggleSearch(showSearch: false));
              },
            ),
        ],
      ),
    );
  }



  //* Update your search_bar.dart to use callbacks instead of direct state management
Widget buildSearchBar({
  required TextEditingController searchController,
  required ValueChanged<String> onChanged,
  required ValueChanged<bool> onSearchToggled,
  required Localization lang,
}) {
  return Container(
    height: 40,
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        const SizedBox(width: 12),
        const Icon(Icons.search, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: lang.SEARCH,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(bottom: 15),
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            style: const TextStyle(fontSize: 16),
            onChanged: onChanged,
            onTap: () => onSearchToggled(true),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.blue),
          onPressed: () {
            searchController.clear();
            onSearchToggled(false);
            onChanged('');
          },
        ),
      ],
    ),
  );
}


  Widget buildSearchResults(List<StudentModel> filteredStudents , Localization lang) {
    return ListView.builder(
      itemCount: filteredStudents.length,
      itemBuilder: (context, index) {
        final student = filteredStudents[index];
        return buildStudentCard(student, context , lang);
      },
    );
  }