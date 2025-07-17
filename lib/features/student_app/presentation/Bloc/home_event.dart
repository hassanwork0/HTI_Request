import 'package:tables/features/student_app/data/models/student_model.dart';

abstract class HomeEvent {}

class SearchTextChanged extends HomeEvent {
  final String searchText;
  final List<StudentModel> allStudents;

  SearchTextChanged(this.searchText, this.allStudents);
}

class ToggleSearch extends HomeEvent {
  final bool showSearch;

  ToggleSearch({required this.showSearch});
}

class ChangeLanguage extends HomeEvent {
  final bool isArabic;

  ChangeLanguage({required this.isArabic});
}

class YearFilterChanged extends HomeEvent {  // Add "implements HomeEvent"
  final String selectedYear;
  final List<StudentModel> allStudents;

  YearFilterChanged(this.selectedYear, this.allStudents);
}
