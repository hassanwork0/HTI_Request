import 'package:tables/features/morshed_app/domain/entities/request.dart';
import 'package:tables/features/student_app/data/models/course_model.dart';

class RequestModel extends Request {
  RequestModel({
    required super.id,
    required super.student,
    required super.course,
    required super.morshedId,
    required super.morshedDr,
    required super.morshedEng,
    required super.isSummer,
    required super.status,
    super.rejectionReason,
    super.comment,
  });

  // Convert to JSON - stores only student IDs
  Map<String, dynamic> toJson() {
        
        return{ 'id': id,
        'course': {
          'id': course.id,
          'name': course.name,
          'units': course.units,
          'department': course.departmentCode
        },
        'morshed': {
          'morshedId': morshedId,
          'morshedDr': morshedDr,
          'morshedEng': morshedEng,
        },
        'student': student.toString(),
        'isSummer': isSummer,
        'status': status,
        'rejectionReason': rejectionReason ?? '',
        'comment': '',
        // Removed FieldValue from here
      };
      }

  // Convert from JSON - requires full student list to reconstruct
factory RequestModel.fromJson(Map<String, dynamic> json) {
  // print('From JSON Data : ');
  // print(json['id']);
  // print(json['student']);
  // print(CourseModel.fromJson(json['course']));
  // print(json['morshed']['morshedId']);
  // print(json['morshed']['morshedDr']);
  // print(json['morshed']['morshedEng']);
  // print(json['isSummer']);
  // print(json['rejectionReason']);
  // print('=============================');
  return RequestModel(
    id: json['id'] ?? '0', // Auto-generated if missing
    student: int.parse(json['student']),
    course: CourseModel.fromJson(json['course']),
    morshedId: json['morshed']['morshedId'],
    morshedDr: json['morshed']['morshedDr'],
    morshedEng: json['morshed']['morshedEng'],
    isSummer: json['isSummer'] ?? false,
    status: json['status'],
    rejectionReason: json['rejectionReason'] ??'',
    comment: json['comment'] ??'',
  );
}

  // Convert to Entity
  Request toEntity() {
    return Request(
      id: id,
      student: student,
      course: course,
      morshedId: morshedId,
      morshedDr: morshedDr,
      morshedEng: morshedEng,
      isSummer: isSummer,
      status: status,
      rejectionReason: rejectionReason,
      comment: comment,
    );
  }

  // Convert from Entity
  factory RequestModel.fromEntity(Request entity) {
    return RequestModel(
      id: entity.id,
      student: entity.student,
      course: entity.course,
      morshedId: entity.morshedId,
      morshedDr: entity.morshedDr,
      morshedEng: entity.morshedEng,
      isSummer: entity.isSummer,
      status: entity.status,
      rejectionReason: entity.rejectionReason,
      comment: entity.comment,
    );
  }

  @override
  String toString() {
    return '''
      id: $id,
      students: $student,
      course: $course,
      morshedDr: $morshedDr,
      morshedEng: $morshedEng,
      isSummer: $isSummer,
      status: $status,
      rejectionReason: $rejectionReason,
      comment: $comment,
''';
  }
}

class RequestStats {
  final int totalRequests;
  final int pendingCount;
  final int acceptedCount;
  final int rejectedCount;
  
  RequestStats({
    required this.totalRequests,
    required this.pendingCount,
    required this.acceptedCount,
    required this.rejectedCount,
  });
}

// enum RequestStatus {
//   pending,
//   accepted,
//   rejected,
// }