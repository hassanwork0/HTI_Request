import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/Bloc/home_bloc.dart';
import 'package:tables/features/student_app/presentation/Bloc/home_event.dart';
import 'package:tables/features/student_app/presentation/Bloc/home_state.dart';
import 'package:tables/features/student_app/presentation/widgets/home/build_home.dart';
import 'package:tables/features/student_app/presentation/widgets/search_bar.dart';
import 'package:tables/features/student_app/presentation/widgets/top_bar/app_bar.dart';

class HomeScreen extends StatelessWidget {
  final List<StudentModel> students;
  final StudentModel student;
  final bool logedIn;

  const HomeScreen({
    super.key, 
    required this.students, 
    required this.student,
    required this.logedIn
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        initialStudents: students,
        initialLang: Localization(false),
      ),
      child: _HomeScreenContent(students: students, student: student,  logedIn: logedIn,),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  final List<StudentModel> students;
  final StudentModel student;
  final TextEditingController searchController = TextEditingController();
  final bool logedIn;

  _HomeScreenContent({
    required this.students,
    required this.student,
    required this.logedIn
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: state.showSearchResults 
              ? 
              //? Filter Students
              buildSearchBar(
                  searchController: searchController,
                  onChanged: (value) {
                    context.read<HomeBloc>().add(
                      SearchTextChanged(value, students)
                    );
                  },
                  onSearchToggled: (show) {
                    context.read<HomeBloc>().add(ToggleSearch(showSearch: show));
                    if (!show) searchController.clear();
                  },
                  lang: state.lang,
                )
              : buildTopMenu(
                  state.lang,
                  context,
                  student,
                  logedIn,
                ),
            automaticallyImplyLeading: false,
          ),
          body: state.showSearchResults 
            ? buildSearchResults(state.filteredStudents ,state.lang) 
            : buildHomeContent(context , state.lang, students, searchController, state.showSearchResults, state.filteredStudents)
        );
      },
    );
  }
}



