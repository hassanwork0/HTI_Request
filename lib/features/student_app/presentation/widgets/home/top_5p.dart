import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/Bloc/home_bloc.dart';
import 'package:tables/features/student_app/presentation/Bloc/home_event.dart';
import 'package:tables/features/student_app/presentation/widgets/home/show_allstudents.dart';
import 'package:tables/features/student_app/presentation/widgets/home/stats.dart';

Widget buildPickTop5Card(
    List<StudentModel> allStudents, Localization lang, BuildContext context) {
  final bloc = context.read<HomeBloc>();
  final state = bloc.state;

  // Extract years from student IDs (assuming format: 32021313 → year is 2021)
  final years = allStudents
      .map((student) => student.id.toString().substring(1, 5)) // Get positions 1-4 (the year)
      .toSet()
      .toList();

  return Column(
    children: [
      buildPickedRankedListCard(
        title: lang.TOP5_P,
        students: allStudents // Use allStudents for initial filtering
            .where((student) =>
                state.selectedYear == null ||
                student.id.toString().substring(1, 5) == state.selectedYear)
            .toList()
            .sortedByGpa()
            .take(5)
            .toList(),
        yearDropdown: years.isNotEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: state.selectedYear,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    dropdownColor: Colors.blue[800],
                    underline: Container(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        bloc.add(YearFilterChanged(
                            newValue, allStudents));
                      }
                    },
                    items: years.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.list, color: Colors.white),
                    tooltip: lang.SHOW_ALL_STUDENTS,
                    onPressed: () {
                      if (state.selectedYear != null) {
                        showAllStudentsDialog(
                          context,
                          allStudents
                              .where((student) =>
                                  student.id.toString().substring(1, 5) ==
                                  state.selectedYear)
                              .toList()
                              .sortedByGpa(),
                          state.selectedYear!,
                          lang,
                        );
                      }
                    },
                  ),
                ],
              )
            : null,
      ),
    ],
  );
}

extension StringSorting on List<String> {
  List<String> sorted() => [...this]..sort();
}

extension StudentSorting on List<StudentModel> {
  List<StudentModel> sortedByGpa() =>
      [...this]..sort((a, b) => b.gpa.compareTo(a.gpa));
}

Widget buildPickedRankedListCard({
  required String title,
  required List<StudentModel> students,
  Widget? yearDropdown,
}) {
  return Card(
    margin: const EdgeInsets.all(16),
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[100]!,
              Colors.grey[50]!,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (yearDropdown != null) yearDropdown,
                ],
              ),
            ),
            if (students.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No students found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...students.map((student) {
                final rank = students.indexOf(student) + 1;
                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: getRankColor(rank),
                        child: Text(
                          '$rank',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        student.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        'ID: ${student.id}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: trailing(student.gpa),
                    ),
                    if (rank < students.length)
                      Divider(
                        height: 1,
                        color: Colors.grey[300],
                        indent: 16,
                        endIndent: 16,
                      ),
                  ],
                );
              }),
          ],
        ),
      ),
    ),
  );
}