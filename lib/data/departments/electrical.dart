
import 'package:tables/data/departments/department.dart';
import 'package:tables/features/student_app/data/models/course_model.dart';

class Electrical implements Department {
  @override
  final String name = 'Telecom Engineering';
  @override
  final String code = 'ELEC';
  
  Electrical();
  
  factory Electrical.fromJson(Map<String, dynamic> json) {
    return Electrical();
  }
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
    };
  }
  
  @override
  String toString() => name;

  static final List<CourseModel> generalCoursesList = [
    CourseModel(name: "Computer Skills", id: "CSC 001", units: 0,departmentCode:'ELEC'),
    CourseModel(
        name: "Communication & Presentation Skills", id: "HUM 108", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Analysis & Research Skills", id: "HUM 109", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Principles of Negotiation", id: "HUM 204", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Human Rights", id: "HUM 205", units: 1,departmentCode:'ELEC'),
    CourseModel(name: "English Language (1)", id: "LNG 001", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "English Language (2)", id: "LNG 002", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Arabic Language", id: "LNG 003", units: 2,departmentCode:'ELEC'),
    CourseModel(
        name: "Physical Education & Activities (1)", id: "PHE 001", units: 0,departmentCode:'ELEC'),
    CourseModel(
        name: "Physical Education & Activities (2)", id: "PHE 101", units: 0,departmentCode:'ELEC'),
    CourseModel(
        name: "Physical Education & Activities (3)", id: "PHE 201", units: 1,departmentCode:'ELEC'),
    CourseModel(name: "Introduction to Field Training", id: "FTR 031", units: 3,departmentCode:'ELEC'),
  ];

  static final List<CourseModel> requirementCoursesList = [
    CourseModel(name: "Field Training (1)", id: "FTR 131", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Field Training (2)", id: "FTR 161", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Mathematics (1)", id: "MTH 001", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Mathematics (2)", id: "MTH 002", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Statistics & Probability Theory", id: "MTH 105", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Physics (1)", id: "PHY 001", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Physics (2)", id: "PHY 002", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Engineering Mechanics (1)", id: "ENG 001", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Engineering Mechanics (2)", id: "ENG 002", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Engineering Chemistry", id: "CHM 001", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Environmental Impact of Projects", id: "MNG 202", units: 1,departmentCode:'ELEC'),
    CourseModel(
        name: "Engineering Drawing & Projection (1)", id: "ENG 003", units: 2,departmentCode:'ELEC'),
    CourseModel(
        name: "Engineering Drawing & Projection (2)", id: "ENG 004", units: 2,departmentCode:'ELEC'),
    CourseModel(
        name: "History of Engineering & Technology", id: "ENG 006", units: 1,departmentCode:'ELEC'),
    CourseModel(
        name: "Principles of Production Technology & Workshop",
        id: "ENG 005",
        units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Project Management", id: "MNG 201", units: 2,departmentCode:'ELEC'),
    CourseModel(
        name: "Monitoring & Quality Control Systems", id: "MNG 101", units: 1,departmentCode:'ELEC'),
    CourseModel(name: "Engineering Economics", id: "MNG 102", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Technical Report Writing", id: "MNG 103", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Professional Ethics", id: "MNG 203", units: 1,departmentCode:'ELEC'),
    CourseModel(name: "Mathematics (3)", id: "MTH 101", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Mathematics (4)", id: "MTH 102", units: 3,departmentCode:'ELEC'),
  ];

  static final List<CourseModel> majorRequirementCoursesList = [
    CourseModel(name: "Logic Design (1)", id: "EEC 112", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Computer Engineering (1)", id: "EEC 113", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Signal Analysis and Systems", id: "EEC 115", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Electric Circuits (2)", id: "EEC 121", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Electrical Measurements", id: "EEC 123", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Computer Engineering (2)", id: "EEC 124", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Control Systems (1)", id: "EEC 125", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Electronics (2)", id: "EEC 141", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Logic Design (2)", id: "EEC 142", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Electronics (3)", id: "EEC 151", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Electromagnetic Fields (1)", id: "EEC 152", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Electrical Machines", id: "EEC 154", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Electromagnetic Fields (2)", id: "EEC 211", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Control Systems (2)", id: "EEC 212", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Communications (1)", id: "EEC 213", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Microprocessors", id: "EEC 214", units: 4,departmentCode:'ELEC'),
    CourseModel(
        name: "Computer Architecture and Organization",
        id: "EEC 216",
        units: 4,departmentCode:'ELEC'),
    CourseModel(name: "Microwave Engineering", id: "EEC 222", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Communications (2)", id: "EEC 223", units: 3,departmentCode:'ELEC'),
    CourseModel(
        name: "Data Communication and Computer Networks",
        id: "EEC 224",
        units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Digital Signal Processing (1)", id: "EEC 225", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Antennas", id: "EEC 241", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Communications (3)", id: "EEC 242", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Communications (4)", id: "EEC 251", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Industrial Process Control", id: "EEC 255", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Bachelor Project", id: "EEC 290", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Field Training (3)", id: "FTR 231", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Field Training (4)", id: "FTR 261", units: 3,departmentCode:'ELEC'),
  ];

// One Course (List D)
static final List<CourseModel> economicOptCourses = [
  CourseModel(name: "Introduction To Accounting", id: "HUM 201", units: 2, departmentCode:'ELEC', electiveName: 'List D'),
  CourseModel(name: "English Literature", id: "HUM 202", units: 2, departmentCode:'ELEC', electiveName: 'List D'),
  CourseModel(name: "Trade Law", id: "HUM 203", units: 2, departmentCode:'ELEC', electiveName: 'List D'),
  CourseModel(name: "Entrepreneurship", id: "HUM 206", units: 2, departmentCode:'ELEC', electiveName: 'List D'),
  CourseModel(name: "Scientific Thinking", id: "HUM 207", units: 2, departmentCode:'ELEC', electiveName: 'List D'),
  CourseModel(name: "Business Administration", id: "HUM 208", units: 2, departmentCode:'ELEC', electiveName: 'List D'),
];

// Two Courses (List E)
static final List<CourseModel> cultureOptCourses = [
  CourseModel(name: "Introduction To The History of Civilizations", id: "HUM 101", units: 2, departmentCode:'ELEC', electiveName: 'List E'),
  CourseModel(name: "Recent Egypt's History", id: "HUM 102", units: 2, departmentCode:'ELEC', electiveName: 'List E'),
  CourseModel(name: "Arab & Islamic Civilization", id: "HUM 103", units: 2, departmentCode:'ELEC', electiveName: 'List E'),
  CourseModel(name: "Literary Appreciation", id: "HUM 104", units: 2, departmentCode:'ELEC', electiveName: 'List E'),
  CourseModel(name: "Music Appreciation", id: "HUM 105", units: 2, departmentCode:'ELEC', electiveName: 'List E'),
  CourseModel(name: "Heritage Of Egyptian Literature", id: "HUM 106", units: 2, departmentCode:'ELEC', electiveName: 'List E'),
  CourseModel(name: "Trends in Contemporary Arts", id: "HUM 107", units: 2, departmentCode:'ELEC', electiveName: 'List E'),
  CourseModel(name: "French Language", id: "LNG 101", units: 2, departmentCode:'ELEC', electiveName: 'List E'),
  CourseModel(name: "German Language", id: "LNG 102", units: 2, departmentCode:'ELEC', electiveName: 'List E'),
];

// Three Courses (List F)
static final List<CourseModel> introCourses = [
  CourseModel(name: "Principles of Construction & Building Engineering", id: "CIV 101", units: 2, departmentCode:'ELEC', electiveName: 'List F'),
  CourseModel(name: "Arts & Architecture", id: "ARE 101", units: 2, departmentCode:'ELEC', electiveName: 'List F'),
  CourseModel(name: "Principles of Electrical Engineering", id: "EEC 101", units: 2, departmentCode:'ELEC', electiveName: 'List F'),
  CourseModel(name: "Principles of Electronic Engineering", id: "EEC 102", units: 2, departmentCode:'ELEC', electiveName: 'List F'),
  CourseModel(name: "Principles of Electric Machines", id: "EEC 103", units: 2, departmentCode:'ELEC', electiveName: 'List F'),
  CourseModel(name: "Principles of Design & Manufacturing Engineering", id: "ENG 103", units: 2, departmentCode:'ELEC', electiveName: 'List F'),
  CourseModel(name: "Principles of Mechanical Power Engineering", id: "ENG 104", units: 2, departmentCode:'ELEC', electiveName: 'List F'),
  CourseModel(name: "Principles of Mechatronics Engineering", id: "MTE 101", units: 2, departmentCode:'ELEC', electiveName: 'List F'),
  CourseModel(name: "Principles of Biomedical Engineering", id: "MDE 101", units: 2, departmentCode:'ELEC', electiveName: 'List F'),
];

// Three Courses (List G)
static final List<CourseModel> mathOptCourses = [
  CourseModel(name: "Numerical Methods", id: "MTH 103", units: 3, departmentCode:'ELEC', electiveName: 'List G'),
  CourseModel(name: "Mathematical Analysis", id: "MTH 104", units: 3, departmentCode:'ELEC', electiveName: 'List G'),
  CourseModel(name: "Advanced Calculus", id: "MTH 206", units: 3, departmentCode:'ELEC', electiveName: 'List G'),
  CourseModel(name: "Selected Topics in Mathematics", id: "MTH 210", units: 3, departmentCode:'ELEC', electiveName: 'List G'),
  CourseModel(name: "Quantum Physics", id: "PHY 111", units: 3, departmentCode:'ELEC', electiveName: 'List G'),
];

// Four Courses (List H)
static final List<CourseModel> departmentOptCourses = [
  CourseModel(name: "Artificial Intelligence", id: "EEC 271", units: 3, departmentCode:'ELEC', electiveName: 'List H'),
  CourseModel(name: "Introduction to Medical Electronics", id: "EEC 272", units: 3, departmentCode:'ELEC', electiveName: 'List H'),
  CourseModel(name: "Advanced Optical Fiber Communications", id: "EEC 273", units: 3, departmentCode:'ELEC', electiveName: 'List H'),
  CourseModel(name: "Advanced Mobile Communication", id: "EEC 274", units: 3, departmentCode:'ELEC', electiveName: 'List H'),
  CourseModel(name: "Advanced Control Engineering", id: "EEC 276", units: 3, departmentCode:'ELEC', electiveName: 'List H'),
  CourseModel(name: "Wireless Network & Applications", id: "EEC 277", units: 3, departmentCode:'ELEC', electiveName: 'List H'),
  CourseModel(name: "Power Electronics", id: "EEC 278", units: 3, departmentCode:'ELEC', electiveName: 'List H'),
  CourseModel(name: "Introduction to Mechatronics", id: "EEC 279", units: 3, departmentCode:'ELEC', electiveName: 'List H'),
  CourseModel(name: "Communication Security Systems", id: "EEC 280", units: 3, departmentCode:'ELEC', electiveName: 'List H'),
  CourseModel(name: "Advanced Electronics", id: "EEC 281", units: 3, departmentCode:'ELEC', electiveName: 'List H'),
  CourseModel(name: "Electronics (4)", id: "EEC 282", units: 3, departmentCode:'ELEC', electiveName: 'List H'),
  CourseModel(name: "Electronics Instrumentation", id: "EEC 283", units: 3, departmentCode:'ELEC', electiveName: 'List H'),
  CourseModel(name: "Advanced Satellite Communication", id: "EEC 284", units: 3, departmentCode:'ELEC', electiveName: 'List H'),
  CourseModel(name: "Computer Engineering (3)", id: "EEC 285", units: 3, departmentCode:'ELEC', electiveName: 'List H'),
  CourseModel(name: "Neuro Fuzzy Control", id: "EEC 286", units: 3, departmentCode:'ELEC', electiveName: 'List H'),
  CourseModel(name: "Selected Topics in Medical Electronics", id: "EEC 287", units: 3, departmentCode:'ELEC', electiveName: 'List H'),
  CourseModel(name: "Digital Signal Processing (2)", id: "EEC 288", units: 3, departmentCode:'ELEC', electiveName: 'List H'),
  CourseModel(name: "Radar and Electronic warfare Systems", id: "EEC 289", units: 3, departmentCode:'ELEC', electiveName: 'List H'),
];

  @override
  // TODO: implement allCourses
  Map<Map<String, int>, List<CourseModel>> get allCoursesMap => {
        {"Lista A":-1}:generalCoursesList,
        {"List B":-1}:requirementCoursesList,
        {"List C":-1}:majorRequirementCoursesList,
        {"List D":1}:economicOptCourses,
        {"List E":2}:cultureOptCourses,
        {"List F":3}:introCourses,
        {"List G":3}:mathOptCourses,
        {"List H":4}:departmentOptCourses,
  };
  
  @override
  // TODO: implement allCoursesList
  List<CourseModel> get allCoursesList =>[
        ...generalCoursesList,
        ...requirementCoursesList,
        ...majorRequirementCoursesList,
        ...economicOptCourses,
        ...cultureOptCourses,
        ...introCourses,
        ...mathOptCourses,
        ...departmentOptCourses,
  ];
  

  /*
  اختيارى س  -> cultureOptCourses
  اختيارى ب  -> introCourses
  اختيارى أ  -> mathOptCourses
  اختيارى د  -> economicOptCourses
  اختيارى ى  ->  departmentOptCourses

  */

@override
List<Map<String, List<CourseModel>>> get departmentTree =>[
  {"prep":[
    CourseModel(name: "Engineering Chemistry", id: "CHM 001", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Computer Skills", id: "CSC 001", units: 0,departmentCode:'ELEC'),
    CourseModel(name: "Engineering Drawing & Projection (1)", id: "ENG 003", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Engineering Drawing & Projection (2)", id: "ENG 004", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Principles of Production Technology & Workshop", id: "ENG 005", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "History of Engineering & Technology", id: "ENG 006", units: 1,departmentCode:'ELEC'),
    CourseModel(name: "Engineering Mechanics (1)", id: "ENG 001", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Engineering Mechanics (2)", id: "ENG 002", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Introduction to Field Training", id: "FTR 031", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "English Language (1)", id: "LNG 001", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Mathematics (1)", id: "MTH 001", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Physical Education & Activities (1)", id: "PHE 001", units: 0,departmentCode:'ELEC'),
    CourseModel(name: "Physics (1)", id: "PHY 001", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Physics (2)", id: "PHY 002", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Mathematics (2)", id: "MTH 002", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Arabic Language", id: "LNG 003", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "English Language (2)", id: "LNG 002", units: 2,departmentCode:'ELEC'),
  ]},
  {"year1":[
    CourseModel(name: "Logic Design (1)", id: "EEC 112", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Computer Engineering (1)", id: "EEC 113", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Mathematics (3)", id: "MTH 101", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Math Elective (Choose 1)", id: "MTH (1)", units: 3,departmentCode:'ELEC' , electiveName: 'List G'),
    CourseModel(name: "Intro Elective (Choose 1)", id: "EEC (1)", units: 2,departmentCode:'ELEC', electiveName:  'List F'),
    CourseModel(name: "Intro Elective (Choose 1)", id: "EEC (2)", units: 2,departmentCode:'ELEC', electiveName:  'List F'),
    CourseModel(name: "Intro Elective (Choose 1)", id: "EEC (3)", units: 2,departmentCode:'ELEC', electiveName:  'List F'),
    CourseModel(name: "Physical Education & Activities (2)", id: "PHE 101", units: 0,departmentCode:'ELEC'),
    CourseModel(name: "Electric Circuits (2)", id: "EEC 121", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Electrical Measurements", id: "EEC 123", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Computer Engineering (2)", id: "EEC 124", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Mathematics (4)", id: "MTH 102", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Culture Elective (Choose 1)", id: "HUM (1)", units: 2,departmentCode:'ELEC' , electiveName: 'List E'),
    CourseModel(name: "Monitoring & Quality Control Systems", id: "MNG 101", units: 1,departmentCode:'ELEC'),
    CourseModel(name: "Engineering Economics", id: "MNG 102", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Field Training (1)", id: "FTR 131", units: 3,departmentCode:'ELEC'),
  ]},
  {"year2":[
    CourseModel(name: "Electronics (2)", id: "EEC 141", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Logic Design (2)", id: "EEC 142", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Signal Analysis and Systems", id: "EEC 115", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Math Elective (Choose 1)", id: "MTH (2)", units: 3,departmentCode:'ELEC', electiveName: 'List G'),
    CourseModel(name: "Technical Report Writing", id: "MNG 103", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Communication & Presentation Skills", id: "HUM 108", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Analysis & Research Skills", id: "HUM 109", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Electronics (3)", id: "EEC 151", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Electromagnetic Fields (1)", id: "EEC 152", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Electrical Machines", id: "EEC 154", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Control Systems (1)", id: "EEC 125", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Statistics & Probability Theory", id: "MTH 105", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Culture Elective (Choose 1)", id: "HUM (2)", units: 2,departmentCode:'ELEC', electiveName: 'List E'),
    CourseModel(name: "Math Elective (Choose 1)", id: "MTH (3)", units: 3,departmentCode:'ELEC', electiveName: 'List G'),
    CourseModel(name: "Field Training (2)", id: "FTR 161", units: 3,departmentCode:'ELEC'),
  ]},
  {"year3":[
    CourseModel(name: "Electromagnetic Fields (2)", id: "EEC 211", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Industrial Process Control", id: "EEC 255", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Control Systems (2)", id: "EEC 212", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Communications (1)", id: "EEC 213", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Project Management", id: "MNG 201", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Department Elective (Choose 1)", id: "EEC (1)", units: 3,departmentCode:'ELEC', electiveName: 'List H'),
    CourseModel(name: "Digital Signal Processing (1)", id: "EEC 225", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Communications (2)", id: "EEC 223", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Data Communication and Computer Networks", id: "EEC 224", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Microwave Engineering", id: "EEC 222", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Computer Architecture and Organization", id: "EEC 216", units: 4,departmentCode:'ELEC'),
    CourseModel(name: "Department Elective (Choose 1)", id: "EEC (2)", units: 3,departmentCode:'ELEC', electiveName: 'List H'),
    CourseModel(name: "Field Training (3)", id: "FTR 231", units: 3,departmentCode:'ELEC'),
  ]},
  {"year4":[
    CourseModel(name: "Communications (3)", id: "EEC 242", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Antennas", id: "EEC 241", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Microprocessors", id: "EEC 214", units: 4,departmentCode:'ELEC'),
    CourseModel(name: "Environmental Impact of Projects", id: "MNG 202", units: 1,departmentCode:'ELEC'),
    CourseModel(name: "Professional Ethics", id: "MNG 203", units: 1,departmentCode:'ELEC'),
    CourseModel(name: "Physical Education & Activities (3)", id: "PHE 201", units: 1,departmentCode:'ELEC'),
    CourseModel(name: "Human Rights", id: "HUM 205", units: 1,departmentCode:'ELEC'),
    CourseModel(name: "Bachelor Project", id: "EEC 290", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Communications (4)", id: "EEC 251", units: 3,departmentCode:'ELEC'),
    CourseModel(name: "Department Elective (Choose 1)", id: "EEC (3)", units: 3,departmentCode:'ELEC', electiveName: 'List H'),
    CourseModel(name: "Department Elective (Choose 1)", id: "EEC (4)", units: 3,departmentCode:'ELEC', electiveName: 'List H'),
    CourseModel(name: "Economic Elective (Choose 1)", id: "HUM (3)", units: 2,departmentCode:'ELEC', electiveName: 'List D'),
    CourseModel(name: "Principles of Negotiation", id: "HUM 204", units: 2,departmentCode:'ELEC'),
    CourseModel(name: "Field Training (4)", id: "FTR 261", units: 3,departmentCode:'ELEC'),
  ]},
];

}
