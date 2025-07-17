import 'package:tables/features/morshed_app/data/models/morshed_model.dart';
import 'package:tables/features/morshed_app/data/models/request_model.dart';
import 'package:tables/features/morshed_app/domain/repositories/requestes_repo.dart';

class GetRequests {
  final RequestesRepository cr;
  const GetRequests({required this.cr});

  Future<List<RequestModel>> call(MorshedModel morshed, {String? status, int? limit}) {
    return cr.getMorshedRequests(morshed: morshed, status: status, limit: limit);
  }
}

class RespondToRequest {
  final RequestesRepository cr;
  const RespondToRequest({required this.cr});

  Future<void> call(String requestId, String response, {String? rejectionReason}) {
    return cr.respondToRequest(
      requestId: requestId,
      response: response,
      rejectionReason: rejectionReason,
    );
  }
}

class GetRequestStats {
  final RequestesRepository cr;
  const GetRequestStats({required this.cr});

  Future<RequestStats> call(MorshedModel morshed) {
    return cr.getRequestStats(morshed);
  }
}

class RespondToMultipleRequests {
  final RequestesRepository cr;
  const RespondToMultipleRequests({required this.cr});

  Future<void> call(List<String> requestIds, String response, {String? rejectionReason}) {
    return cr.respondToMultipleRequests(
      requestIds: requestIds,
      response: response,
      rejectionReason: rejectionReason,
    );
  }
}