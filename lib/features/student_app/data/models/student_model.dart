import 'package:tables/data/departments/department.dart';
import 'package:tables/features/morshed_app/data/models/morshed_model.dart';
import 'package:tables/features/student_app/data/models/course_model.dart';

import '../../domain/entities/student.dart';

class StudentModel extends Student {
  StudentModel(
      {required super.id,
      required super.name,
      required super.gpa,
      required super.units,
      required super.department,
      required super.morshedDr,
      required super.morshedEng,
      super.coursesFinished,
      super.faildCourses,
      super.currentCourses,});


//! Make Get The Docotr and Eng from Collectioins using the IDs
  factory StudentModel.fromJson(Map<String, dynamic> json) {
    final morshedDr = json['morshedDr'] as Map<String,dynamic>;
    final morshedEng = json['morshedEng'] as Map<String,dynamic>;
    

    return StudentModel(
      id: json['id'] as int,
      name: json['name'] as String,
      gpa: (json['gpa'] as num).toDouble(),
      units: (json['units'] as num).toDouble(),
      department:
          Department.fromJson(json['department']), // Deserialize department
      
      //!Here 
      morshedDr:MorshedModel.fromJson(morshedDr),

      //!And Here
      morshedEng: MorshedModel.fromJson(morshedEng),


      coursesFinished: json['coursesFinished'] != null
          ? List<CourseModel>.from(
              json['coursesFinished'].map((x) => CourseModel.fromJson(x)))
          : <CourseModel>[],
      faildCourses: json['faildCourses'] != null
          ? List<CourseModel>.from(
              json['faildCourses'].map((x) => CourseModel.fromJson(x)))
          : <CourseModel>[],

          
        //! The Dart need this for storing a local and cloud current List
                currentCourses: json['currentCourses'] != null
          ? List<CourseModel>.from(
              json['currentCourses'].map((x) => CourseModel.fromJson(x)))
          : <CourseModel>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gpa': gpa,
      'units': units,
      'department': {
        // Simplified department representation
        'type': 'electrical',
        'name': department.name,
        'code': department.code,
      },
      'morshedDr': {
        'id' : morshedDr.id,
        'name' : morshedDr.name,
        'department':morshedDr.department.name
      },
      'morshedEng': {
        'id' : morshedEng.id,
        'name' : morshedEng.name,
        'department':morshedEng.department.name
      },
      'coursesFinished': coursesFinished.map((c) => c.toJson()).toList(),
      'faildCourses': faildCourses.map((c) => c.toJson()).toList(),

      //! Needed in the future
      'currentCourses': currentCourses.map((c) => c.toJson()).toList(),

    };
  }
}
