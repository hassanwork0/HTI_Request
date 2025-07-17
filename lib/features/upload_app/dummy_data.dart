import 'package:tables/data/departments/department.dart';
import 'package:tables/data/departments/electrical.dart';
import 'package:tables/features/student_app/data/models/course_model.dart';


class Data{
  Map<int, dynamic> morshedDrs = {
    0: {
      'login_name': 'mahmoud_hamed',
      'password': 'drpass0',
      'name': 'د/ محمود حامد',
      'department': {
        // Simplified department representation
        'type': 'electrical',
        'name': Electrical().name,
        'code': Electrical().code,
      },
      'last_year_student': 32020117,
    },
    1: {
      'login_name': 'mina_dawood',
      'password': 'drpass1',
      'name': 'د/ مينا داود',
      'department': {
        // Simplified department representation
        'type': 'electrical',
        'name': Electrical().name,
        'code': Electrical().code,
      },
      'last_year_student': 32020265,
    },
    2: {
      'login_name': 'suzan_shokry',
      'password': 'drpass2',
      'name': 'د/ سوزان شكري',
      'department': {
        // Simplified department representation
        'type': 'electrical',
        'name': Electrical().name,
        'code': Electrical().code,
      },
      'last_year_student': 32021215,
    },
    3: {
      'login_name': 'ramz_hassan',
      'password': 'drpass3',
      'name': 'د/ رامز حسن',
      'department': {
        // Simplified department representation
        'type': 'electrical',
        'name': Electrical().name,
        'code': Electrical().code,
      },
      'last_year_student': 32021495,
    },
    4: {
      'login_name': 'kareem_badr',
      'password': 'drpass4',
      'name': 'د/ كريم بدر الدين',
      'department': {
        // Simplified department representation
        'type': 'electrical',
        'name': Electrical().name,
        'code': Electrical().code,
      },
      'last_year_student': 32022199,
    },
    5: {
      'login_name': 'kareem_badawy',
      'password': 'drpass5',
      'name': 'د/ كريم بدوي',
      'department': {
        // Simplified department representation
        'type': 'electrical',
        'name': Electrical().name,
        'code': Electrical().code,
      },
      'last_year_student': 32023163,
    },
    6: {
      'login_name': 'suzan_elgarhy',
      'password': 'drpass6',
      'name': 'د/ سوزان الجارحي',
      'department': {
        // Simplified department representation
        'type': 'electrical',
        'name': Electrical().name,
        'code': Electrical().code,
      },
      'last_year_student': 32024031,
    },
  };

  Map<int, dynamic> morshedEngs = {
    32000: {
      'login_name': 'mohamed_ragab',
      'password': 'engpass0',
      'name': 'م/ محمد رجب',
      'department': {
        // Simplified department representation
        'type': 'electrical',
        'name': Electrical().name,
        'code': Electrical().code,
      },
      'doctor_id': 0,
    },
    32001: {
      'login_name': 'mariam',
      'password': 'engpass1',
      'name': 'م/ مريم',
      'department': {
        // Simplified department representation
        'type': 'electrical',
        'name': Electrical().name,
        'code': Electrical().code,
      },
      'doctor_id': 1,
    },
    32002: {
      'login_name': 'rowan1',
      'password': 'engpass2',
      'name': 'م/ روان',
      'department': {
        // Simplified department representation
        'type': 'electrical',
        'name': Electrical().name,
        'code': Electrical().code,
      },
      'doctor_id': 2,
    },
    32003: {
      'login_name': 'nourhan',
      'password': 'engpass3',
      'name': 'م/ نورهان',
      'department': {
        // Simplified department representation
        'type': 'electrical',
        'name': Electrical().name,
        'code': Electrical().code,
      },
      'doctor_id': 3,
    },
    32004: {
      'login_name': 'doha',
      'password': 'engpass4',
      'name': 'م/ ضحي',
      'department': {
        // Simplified department representation
        'type': 'electrical',
        'name': Electrical().name,
        'code': Electrical().code,
      },
      'doctor_id': 4,
    },
    32005: {
      'login_name': 'asmaa',
      'password': 'engpass5',
      'name': 'م/ أسماء',
      'department': {
        // Simplified department representation
        'type': 'electrical',
        'name': Electrical().name,
        'code': Electrical().code,
      },
      'doctor_id': 5,
    },
    32006: {
      'login_name': 'rowan2',
      'password': 'engpass6',
      'name': 'م/ روان',
      'department': {
        // Simplified department representation
        'type': 'electrical',
        'name': Electrical().name,
        'code': Electrical().code,
      },
      'doctor_id': 6,
    },
  };

  CourseModel getCourse(String id, Department department) {
    return <CourseModel>[...department.allCoursesList].firstWhere(
      (course) {
        return course.id == id.trim().toUpperCase();
      },
      orElse: () => CourseModel(
          name: "Course Not Found", id: id, units: 0, departmentCode: 'ELEC'),
    );
  }
}
