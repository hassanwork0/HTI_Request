import 'package:tables/core/localization/localization.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';

class HomeState {
  final bool showSearchResults;
  final List<StudentModel> filteredStudents;
  final Localization lang;
  final String? searchQuery;
  final String? selectedYear;
  final List<String> availableYears;

  HomeState({
    required this.showSearchResults,
    required this.filteredStudents,
    required this.lang,
    this.searchQuery,
    this.selectedYear,
    required this.availableYears,
  });

  factory HomeState.initial({
    required List<StudentModel> initialStudents,
    required Localization initialLang,
  }) {
    final years = initialStudents
        .map((student) => '${student.id}'.substring(1, 5))
        .toSet()
        .toList();

    return HomeState(
      showSearchResults: false,
      filteredStudents: initialStudents,
      lang: initialLang,
      availableYears: years,
      selectedYear: years.isNotEmpty ? years.last : null,
    );
  }

  HomeState copyWith({
    bool? showSearchResults,
    List<StudentModel>? filteredStudents,
    Localization? lang,
    String? searchQuery,
    String? selectedYear,
    List<String>? availableYears,
  }) {
    return HomeState(
      showSearchResults: showSearchResults ?? this.showSearchResults,
      filteredStudents: filteredStudents ?? this.filteredStudents,
      lang: lang ?? this.lang,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedYear: selectedYear ?? this.selectedYear,
      availableYears: availableYears ?? this.availableYears,
    );
  }
}