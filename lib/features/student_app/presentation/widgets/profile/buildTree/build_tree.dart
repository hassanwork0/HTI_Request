import 'package:flutter/material.dart';
import 'package:tables/data/departments/department.dart';
import 'package:tables/features/morshed_app/data/models/request_model.dart';
import 'package:tables/features/morshed_app/data/sources/request_remote_data.dart';
import 'package:tables/features/student_app/data/models/course_model.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';

void buildCourseTreePopup(BuildContext context, StudentModel student) {
  final finishedCourseIds = student.coursesFinished.map((c) => c.id).toList();
  final requestsRepo = RequestRemoteData();

  showDialog(
    
    context: context,
    builder: (context) {
      return FutureBuilder<List<RequestModel>>(
        future: requestsRepo.getStudentRequests(student: student),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data ?? [];
          
          return AlertDialog(
            title: Center(child: Text('Department Tree | Current units ${student.units} ')),
            backgroundColor: Colors.white,
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildYearColumn('Preparatory Year', student.department.departmentTree[0]['prep']!, finishedCourseIds, student.department, requests , student),
                      const SizedBox(width: 16),
                      _buildYearColumn('First Year', student.department.departmentTree[1]['year1']!, finishedCourseIds, student.department, requests , student),
                      const SizedBox(width: 16),
                      _buildYearColumn('Second Year', student.department.departmentTree[2]['year2']!, finishedCourseIds, student.department, requests , student),
                      const SizedBox(width: 16),
                      _buildYearColumn('Third Year', student.department.departmentTree[3]['year3']!, finishedCourseIds, student.department, requests , student),
                      const SizedBox(width: 16),
                      _buildYearColumn('Fourth Year', student.department.departmentTree[4]['year4']!, finishedCourseIds, student.department, requests , student),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _buildCourseTile(CourseModel course, List<String?> finishedCourseIds, List<RequestModel>? requests, StudentModel student) {
  final isFinished = finishedCourseIds.contains(course.id);
  final isCurrent = student.currentCourses.any((c) => c.id == course.id);
  
  // Check if this course has any requests
  final courseRequests = requests?.where((r) => r.course.id == course.id).toList();
  final requestStatus = courseRequests?.isNotEmpty == true 
      ? courseRequests!.first.status 
      : null;

  Color borderColor = isFinished ? Colors.green : Colors.black;
  Color bgColor = Colors.transparent;
  
  // Set colors based on request status or current enrollment
  if (isCurrent) {
    borderColor = Colors.orange;
    bgColor = Colors.orange.withOpacity(0.2);
  } 
  else if (requestStatus != null) {
    switch (requestStatus) {
      case 'pending':
        borderColor = Colors.orange;
        bgColor = Colors.orange.withOpacity(0.2);
        break;
      case 'rejected':
        borderColor = Colors.red;
        bgColor = Colors.red.withOpacity(0.2);
        break;
      case 'accepted':
        borderColor = Colors.blue;
        bgColor = Colors.blue.withOpacity(0.2);
        break;
    }
  } else if (isFinished) {
    bgColor = Colors.green.withOpacity(0.2);
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 4),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(32),
      border: Border.all(
        color: borderColor,
        width: 1,
      ),
    ),
    child: ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(
        course.name,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isFinished ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        '${course.id} • ${course.units} units',
        style: TextStyle(
          fontSize: 10,
          color: borderColor,
        ),
      ),
      trailing: isFinished 
          ? const Icon(Icons.check_circle, color: Colors.green, size: 16)
          : isCurrent
              ? const Icon(Icons.school, color: Colors.orange, size: 16)
              : requestStatus != null
                  ? Icon(
                      _getStatusIcon(requestStatus),
                      size: 16,
                      color: borderColor,
                    )
                  : null,
    ),
  );
}

Widget _buildElectiveTile(CourseModel placeholder, List<String?> finishedCourseIds, Department department, List<RequestModel>? requests, StudentModel student) {
  // Get the elective list from allCoursesMap
  final electiveListEntry = department.allCoursesMap.entries.firstWhere(
    (entry) => entry.key.keys.first == placeholder.electiveName,
    orElse: () => MapEntry({}, []),
  );
  
  if (electiveListEntry.key.isEmpty) {
    return _buildCourseTile(placeholder, finishedCourseIds, requests, student);
  }

  final electiveList = electiveListEntry.value;
  final requiredCount = electiveListEntry.key.values.first;
  
  // Find completed courses in this elective list
  final completedCourses = electiveList.where((c) => finishedCourseIds.contains(c.id)).toList();
  
  // Track expanded state
  bool isExpanded = false;

  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: completedCourses.length == requiredCount ? Colors.green.withOpacity(0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: completedCourses.isNotEmpty ? Colors.green : Colors.black,
                  width: 1,
                ),
              ),
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: Text(
                  "${placeholder.name} (${completedCourses.length}/$requiredCount)",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: completedCourses.isNotEmpty ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  '${placeholder.id} • ${placeholder.units} units',
                  style: TextStyle(
                    fontSize: 10,
                    color: completedCourses.isNotEmpty ? Colors.green : Colors.black,
                  ),
                ),
                trailing: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 16,
                  color: completedCourses.isNotEmpty ? Colors.green : Colors.black,
                ),
              ),
            ),
          ),
          if (isExpanded) ...[
            ...electiveList.map((course) {
              final isCourseCompleted = finishedCourseIds.contains(course.id);
              final isCourseCurrent = student.currentCourses.any((c) => c.id == course.id);
              final courseRequests = requests?.where((r) => r.course.id == course.id).toList();
              final requestStatus = courseRequests?.isNotEmpty == true 
                  ? courseRequests!.first.status 
                  : null;

              Color borderColor = isCourseCompleted ? Colors.green : Colors.grey;
              Color bgColor = Colors.transparent;
              
              if (isCourseCurrent) {
                borderColor = Colors.orange;
                bgColor = Colors.orange.withOpacity(0.2);
              }
              else if (requestStatus != null) {
                switch (requestStatus) {
                  case 'pending':
                    borderColor = Colors.orange;
                    bgColor = Colors.orange.withOpacity(0.2);
                    break;
                  case 'rejected':
                    borderColor = Colors.red;
                    bgColor = Colors.red.withOpacity(0.2);
                    break;
                  case 'accepted':
                    borderColor = Colors.blue;
                    bgColor = Colors.blue.withOpacity(0.2);
                    break;
                }
              } else if (isCourseCompleted) {
                bgColor = Colors.green.withOpacity(0.2);
              }

              return Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: borderColor,
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    title: Text(
                      course.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isCourseCompleted ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      '${course.id} • ${course.units} units',
                      style: TextStyle(
                        fontSize: 10,
                        color: borderColor,
                      ),
                    ),
                    trailing: isCourseCompleted 
                        ? const Icon(Icons.check_circle, color: Colors.green, size: 16)
                        : isCourseCurrent
                            ? const Icon(Icons.school, color: Colors.orange, size: 16)
                            : requestStatus != null
                                ? Icon(
                                    _getStatusIcon(requestStatus),
                                    size: 16,
                                    color: borderColor,
                                  )
                                : null,
                  ),
                ),
              );
            }),
          ],
        ],
      );
    },
  );
}

//! Update the _buildYearColumn to pass the student parameter
Widget _buildYearColumn(String title, List<CourseModel> courses, List<String?> finishedCourseIds, Department department,
List<RequestModel> requests, StudentModel student) {
  return SizedBox(
    width: 250,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ...courses.map((course) {
          // Check if this is an elective placeholder
          if (course.electiveName != null) {
            return _buildElectiveTile(course, finishedCourseIds, department, requests, student);
          }
          return _buildCourseTile(course, finishedCourseIds, requests, student);
        }),
      ],
    ),
  );
}

IconData _getStatusIcon(String status) {
  switch (status) {
    case 'pending':
      return Icons.access_time;
    case 'rejected':
      return Icons.cancel;
    case 'accepted':
      return Icons.check_circle;
    default:
      return Icons.help_outline;
  }
}