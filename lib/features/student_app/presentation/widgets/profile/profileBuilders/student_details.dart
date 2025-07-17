import 'package:flutter/material.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/widgets/profile/profileBuilders/builders.dart';

Transform studentDetails(StudentModel student, bool myProfile,
    Localization lang, BuildContext context ) {
  return Transform.translate(
    offset: const Offset(0, -50),
    child: Column(
      children: [
        // Profile Picture
        profilePicture(student),

        const SizedBox(height: 16),

        // Name
        Text(
          student.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        // ID and Department
        Text(
          'ID: ${student.id} | ${student.department}',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),


        if (myProfile)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildProfileButtons(
                  lang.GPA_SCREEN, const Color(0xFF181D38), context, student , lang),
              buildProfileButtons(lang.TREE_POPUP,
                  const Color.fromARGB(255, 81, 99, 199), context, student , lang),
              buildProfileButtons(lang.REQUEST_SCREEN,
                  const Color.fromARGB(255, 0, 0, 0), context, student , lang),
            ],
          ),
          
        const SizedBox(height: 24),

        // Rest of the content
        academicInfo(student , lang),
      ],
    ),
  );
}

profilePicture(StudentModel student) {
  return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue[500],
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Center(
            child: Text(
              student.name.split(' ')[0],
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        );
}

academicInfo(StudentModel student , Localization lang ) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDetailCard(lang.ACADEMIC_INFORMATION, [
          buildDetailRow(lang.STUDENT_ID, '${student.id}'),
          buildDetailRow(lang.GPA, student.gpa.toStringAsFixed(2)),
          buildDetailRow(lang.UNITS_COMPLETED, '${student.units}'),
        ]),
        const SizedBox(height: 16),
        buildDetailCard(lang.ADVISORS, [
          buildDetailRow(lang.DOCTORAL_ADVISOR, student.morshedDr.name),
          buildDetailRow(lang.ENGINEERING_ADVISOR, student.morshedEng.name),
        ]),
        const SizedBox(height: 24),
        
        ...student.department.allCoursesMap.entries.map((entry) {
          return Column(
            children: [
              buildCourseList(entry.key.keys.first, entry.value,
                  requiredCompletions:entry.key.values.first, student: student),
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    ),
  );
}
