import 'package:flutter/material.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/features/student_app/data/models/course_model.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/navigations/goto_gpaScreen.dart';
import 'package:tables/features/student_app/presentation/widgets/profile/buildRequests/build_request.dart';
import 'package:tables/features/student_app/presentation/widgets/profile/buildTree/build_tree.dart';

Widget buildDetailCard(String title, List<Widget> children) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          ...children,
        ],
      ),
    ),
  );
}

Widget buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    ),
  );
}
Widget buildCourseList(String title, List<CourseModel> courses,
    {required int requiredCompletions, required StudentModel student}) {
  List<String> finishedCourses =
      student.coursesFinished.map((course) => course.id).toList();

  int finishedCount =
      courses.where((course) => finishedCourses.contains(course.id)).length;

  if (requiredCompletions == -1) {
    requiredCompletions = courses.length;
  }

  bool requirementsMet = finishedCount >= requiredCompletions;

  return _buildListDetailCard(
    title,
    courses.map((course) {
      final bool isFinished = finishedCourses.contains(course.id);
      Color statusColor = _courseStatus(isFinished, false).keys.first;
      String statusSymbol = _courseStatus(isFinished, false).values.first;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  statusSymbol,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                course.name,
                style: TextStyle(
                  fontSize: 16,
                  decoration: requirementsMet && !isFinished
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  course.id,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(width: 10),
                Text(
                  course.units.toString(),
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList(),
    allFinished: requirementsMet,
  );
}

Widget _buildListDetailCard(
  String title,
  List<Widget> children, {
  required bool allFinished,
}) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: allFinished
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              decorationColor: Colors.black,
              decorationThickness: 5.0,
            ),
          ),
          const Divider(),
          ...children,
        ],
      ),
    ),
  );
}


Map<Color, String> _courseStatus(bool isFinished, bool isCurrent) {
  if (isFinished) {
    return {Colors.green: '✓'};
  } else if (isCurrent) {
    return {Colors.amber: 'C'};
  } else {
    return {Colors.grey: '✗'};
  }
}

Widget buildProfileButtons(String text, Color color, BuildContext context,
    StudentModel student, Localization lang) {
  return Container(
    margin: const EdgeInsets.all(8),
    child: TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: color,
        foregroundColor: Colors.white,
        overlayColor: Colors.white,
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        if (text == lang.GPA_SCREEN) {
          gotoGpa(context, student);
        } else if(text == lang.REQUEST_SCREEN){
          //make screen with text in the center and button ok
          buildCourseRegistrationPopup(context , student);
        }else {
          buildCourseTreePopup(context, student);
        }
      },
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
    ),
  );
}
