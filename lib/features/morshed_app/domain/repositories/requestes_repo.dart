// Request operations
import 'package:tables/features/morshed_app/data/models/morshed_model.dart';
import 'package:tables/features/morshed_app/data/models/request_model.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';

abstract class RequestesRepository {
  Future<List<RequestModel>> getMorshedRequests(
      {required MorshedModel morshed,
      String? status, // Optional filter
      int? limit});

  Future<void> respondToRequest({
    required String requestId,
    required String response,
    String? rejectionReason,
  });

  // Statistics
  Future<RequestStats> getRequestStats(MorshedModel morshed);

  // Bulk operations
  Future<void> respondToMultipleRequests({
    required List<String> requestIds,
    required String response,
    String? rejectionReason,
  });

  //? Student Requests Functions

  // Request operations
  Future<List<RequestModel>> getStudentRequests({
    required StudentModel student,
  });

  Future<void> sendRequest({
    required StudentModel student,
    required RequestModel request,
    String? optComment,
  });

  Future<void> removeRequestFromStudent({
    required String requestId,
    required int studentId,
  });
}
