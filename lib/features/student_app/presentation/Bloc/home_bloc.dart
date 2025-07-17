import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/Bloc/home_event.dart';
import 'package:tables/features/student_app/presentation/Bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required List<StudentModel> initialStudents,
    required Localization initialLang,
  }) : super(HomeState.initial(
          initialStudents: initialStudents,
          initialLang: initialLang,
        )) {
    on<SearchTextChanged>(_onSearchTextChanged);
    on<ToggleSearch>(_onToggleSearch);
    on<ChangeLanguage>(_onChangeLanguage);
    on<YearFilterChanged>(_onYearFilterChanged);
  }

  void _onSearchTextChanged(SearchTextChanged event, Emitter<HomeState> emit) {
    final filtered = event.allStudents.where((student) {
      final query = event.searchText.toLowerCase();
      return '${student.id}'.toLowerCase().contains(query) ||
          student.name.toLowerCase().contains(query);
    }).toList();

    emit(state.copyWith(
      filteredStudents: filtered,
      searchQuery: event.searchText,
    ));
  }

  void _onToggleSearch(ToggleSearch event, Emitter<HomeState> emit) {
    emit(state.copyWith(showSearchResults: event.showSearch));
  }

  void _onChangeLanguage(ChangeLanguage event, Emitter<HomeState> emit) {
    emit(state.copyWith(lang: Localization(event.isArabic)));
  }

  void _onYearFilterChanged(YearFilterChanged event, Emitter<HomeState> emit) {
    final filtered = event.allStudents
        .where((student) => '${student.id}'.startsWith(event.selectedYear))
        .toList();

    emit(state.copyWith(
      selectedYear: event.selectedYear,
      filteredStudents: filtered,
      searchQuery: null, // Reset search when year changes
    ));
  }
}