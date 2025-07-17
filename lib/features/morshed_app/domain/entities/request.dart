import 'package:tables/features/student_app/data/models/course_model.dart';

class Request {
  final String id;
  final int student;
  final CourseModel course;
  final String morshedId;
  final String morshedDr;
  final String morshedEng;
  
  final bool isSummer;
  String status;
  String? rejectionReason; // If rejected, why?
  String? comment;
  
  Request({
    required this.id,
    required this.student,
    required this.course,
    required this.morshedId,
    required this.morshedDr,
    required this.morshedEng, 
    required this.isSummer,
    this.status = 'pending',
    this.rejectionReason,
    this.comment,
  }) ;

  // bool get isResponded => status != RequestStatus.pending;
}


