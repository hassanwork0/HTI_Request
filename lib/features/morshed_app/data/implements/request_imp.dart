import 'package:tables/features/morshed_app/data/models/morshed_model.dart';
import 'package:tables/features/morshed_app/data/models/request_model.dart';
import 'package:tables/features/morshed_app/data/sources/request_remote_data.dart';
import 'package:tables/features/morshed_app/domain/repositories/requestes_repo.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';

class RequestImp extends RequestesRepository{
  RequestRemoteData rrd = RequestRemoteData();


  @override
  Future<RequestStats> getRequestStats(MorshedModel morshed) {
    
    return rrd.getRequestStats(morshed);
  }

  @override
  Future<List<RequestModel>> getMorshedRequests({required MorshedModel morshed, String? status, int? limit}) {
    return getMorshedRequests(morshed: morshed, status: status , limit: limit);
  }

  @override
  Future<void> respondToMultipleRequests({required List<String> requestIds, required String response, String? rejectionReason}) {
    
    return rrd.respondToMultipleRequests(requestIds: requestIds, response: response);
  }

  @override
  Future<void> respondToRequest({required String requestId, required String response, String? rejectionReason}) {
    return rrd.respondToRequest(requestId: requestId, response: response);
  }

  @override
  Future<List<RequestModel>> getStudentRequests({required StudentModel student}) {
    return rrd.getStudentRequests(student: student);
  }

  @override
  Future<void> sendRequest({required StudentModel student, required RequestModel request, String? optComment}) {
    return rrd.sendRequest(student: student, request: request);
  }
  
  @override
  Future<void> removeRequestFromStudent({required String requestId, required int studentId}) {
    return rrd.removeRequestFromStudent(requestId: requestId, studentId: studentId);
  }


}