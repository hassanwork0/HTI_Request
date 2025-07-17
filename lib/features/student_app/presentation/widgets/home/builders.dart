
import 'package:flutter/material.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/widgets/home/show_allstudents.dart';
import 'package:tables/features/student_app/presentation/widgets/home/stats.dart';

Widget buildRankedListCard({
  required String title,
  required List<StudentModel> students,
  required BuildContext context,
  required String year,
  required Localization lang,
}) {
  // Sort all students by GPA first
  final sortedStudents = [...students]..sort((a, b) => b.gpa.compareTo(a.gpa));
  
  // Filter by year if specified
  final filteredStudents = sortedStudents.where((s) => s.id.toString().startsWith('3$year')).toList();

  // Take top 10 (all years) or top 5 (specific year)
  final topStudents = filteredStudents.take(year.isEmpty ? 10 : 5).toList();

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
                  IconButton(
                    onPressed: () {
                      showAllStudentsDialog(
                        context,
                        filteredStudents,
                     year.isEmpty ?  lang.ALL_YEARS : year,
                        lang,
                      );
                    },
                    icon: const Icon(Icons.list, color: Colors.white),
                    tooltip: lang.SHOW_ALL_STUDENTS,
                  ),
                ],
              ),
            ),
            if (topStudents.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No students found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...topStudents.map((student) {
                final rank = topStudents.indexOf(student) + 1;
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
                    if (rank < topStudents.length)
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