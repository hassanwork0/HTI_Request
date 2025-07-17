import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tables/features/morshed_app/data/models/morshed_model.dart';
import 'package:tables/features/morshed_app/data/models/request_model.dart';
import 'package:tables/features/morshed_app/domain/repositories/requestes_repo.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';

class RequestRemoteData extends RequestesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _drsCollection => _firestore.collection('doctors');
  CollectionReference get _engsCollection => _firestore.collection('engineers');
  CollectionReference get requestsCollection =>
      _firestore.collection('requests');

  // Get student's requests document reference
  DocumentReference _studentRequestsDoc(int studentId) =>
      requestsCollection.doc(studentId.toString());

  @override
  Future<List<RequestModel>> getStudentRequests({
    required StudentModel student,
  }) async {
    try {
      // 1. Get the student's requests document
      final doc = await _studentRequestsDoc(student.id).get();
      if (!doc.exists) return [];

      final data = doc.data() as Map<String, dynamic>;
      final requestsList =
          List<Map<String, dynamic>>.from(data['requests'] ?? []);

      // 2. Get the complete student data
      final studentDoc = await _firestore
          .collection('students')
          .doc(student.id.toString())
          .get();
      if (!studentDoc.exists) throw Exception('Student document not found');
      // final fullStudent = StudentModel.fromJson(studentDoc.data()!);

      // 3. Convert each request to RequestModel
      return requestsList.map((requestJson) {
        return RequestModel.fromJson(requestJson);
      }).toList();
    } catch (e) {
      print(e);
      throw Exception('Failed to get student requests: ${e.toString()}');
    }
  }

  @override
  Future<RequestStats> getRequestStats(MorshedModel morshed) async {
    try {
      // Fetch requests based on morshed type
      // final requests = await getMorshedRequests(morshed: morshed);

      // return RequestStats(
      //   totalRequests: requests.length,
      //   pendingCount:
      //       requests.where((r) => r.status == RequestStatus.pending).length,
      //   acceptedCount:
      //       requests.where((r) => r.status == RequestStatus.accepted).length,
      //   rejectedCount:
      //       requests.where((r) => r.status == RequestStatus.rejected).length,
      // );
      throw Exception("under Construction");
    } catch (e) {
      throw Exception('Failed to get stats: ${e.toString()}');
    }
  }

  @override
  Future<List<RequestModel>> getMorshedRequests({
    required MorshedModel morshed,
    String? status,
    int? limit,
  }) async {
    try {
      // Determine which collection to query based on morshed type
      final collection = morshed.isEngineer ? _engsCollection : _drsCollection;

      // Fetch the morshed document to get request IDs
      final doc = await collection.doc(morshed.id.toString()).get();
      if (!doc.exists || doc.data() == null) {
        return [];
      }

      final data = doc.data() as Map<String, dynamic>;
      final requestIds = List<String>.from(data['requestIds'] ?? []);

      if (requestIds.isEmpty) return [];

      // Process requests in batches
      const batchSize = 10;
      final List<RequestModel> allRequests = [];

      for (var i = 0; i < requestIds.length; i += batchSize) {
        final batchIds = requestIds.sublist(
          i,
          i + batchSize > requestIds.length ? requestIds.length : i + batchSize,
        );

        Query query =
            requestsCollection.where(FieldPath.documentId, whereIn: batchIds);

        if (status != null) {
          query = query.where('status',
              isEqualTo: status.toString().split('.').last);
        }

        if (limit != null) {
          query = query.limit(limit - allRequests.length > batchSize
              ? batchSize
              : limit - allRequests.length);
        }

        final snapshot = await query.get();
        final batchRequests = await Future.wait(
          snapshot.docs.map((doc) async {
            return RequestModel.fromJson(doc.data() as Map<String, dynamic>);
          }),
        );

        allRequests.addAll(batchRequests);

        if (limit != null && allRequests.length >= limit) {
          break;
        }
      }

      return allRequests.take(limit ?? allRequests.length).toList();
    } catch (e) {
      throw Exception('Failed to get requests: ${e.toString()}');
    }
  }

  @override
  Future<void> respondToRequest({
    required String requestId,
    required String response,
    String? rejectionReason,
  }) async {
    try {
      await requestsCollection.doc(requestId).update({
        'status': response.toString().split('.').last,
        if (rejectionReason != null) 'rejectionReason': rejectionReason,
        'respondedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to respond to request: ${e.toString()}');
    }
  }

  @override
  Future<void> respondToMultipleRequests({
    required List<String> requestIds,
    required String response,
    String? rejectionReason,
  }) async {
    try {
      final batch = _firestore.batch();

      for (final requestId in requestIds) {
        final ref = requestsCollection.doc(requestId);
        batch.update(ref, {
          'status': response.toString().split('.').last,
          if (rejectionReason != null) 'rejectionReason': rejectionReason,
          'respondedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
    } catch (e) {
      throw Exception(
          'Failed to respond to multiple requests: ${e.toString()}');
    }
  }

  @override
  Future<void> sendRequest({
    required StudentModel student,
    required RequestModel request,
    String? optComment,
  }) async {
    try {
      final requestData = {
        'id': FirebaseFirestore.instance.collection('requests').doc().id,
        'course': {
          'id': request.course.id,
          'name': request.course.name,
          'units': request.course.units,
          'department': request.course.departmentCode
        },
        'morshed': {
          'morshedId': request.morshedId,
          'morshedDr': request.morshedDr,
          'morshedEng': request.morshedEng,
        },
        'student': student.id.toString(),
        'isSummer': request.isSummer,
        'status': request.status,
        'rejectionReason': request.rejectionReason ?? '',
        'comment': optComment ?? '',
        // Removed FieldValue from here
      };

      // Create a reference to the student's document
      final studentRequestsRef = requestsCollection.doc(student.id.toString());

      final doc = await studentRequestsRef.get();

      if (doc.exists) {
        // Document exists - append new numbers
        final currentData = doc.data() as Map<String, dynamic>;
        final currentRequests =
            List<Map<String, dynamic>>.from(currentData['requests'] ?? []);

        final requestCourseId =
            (requestData['course'] as Map<String, dynamic>)['id'];

        final test = currentRequests.where(
          (element) {
            return element['course']['id'] == requestCourseId;
          },
        );
        if (test.isEmpty) {
          await studentRequestsRef.update({
            'requests': [...currentRequests, requestData], // Append new numbers
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          print("Error");
          throw Exception('Alredy Registered');
        }
      } else {
        // Set simple test data
        await studentRequestsRef.set({
          'requests': [requestData],
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // print('Debug data successfully stored for student ${student.id}');
    } catch (e) {
      print('Error in debug sendRequest: ${e.toString()}');
      throw Exception('Failed to store debug data: ${e.toString()}');
    }
  }

  @override
  Future<void> removeRequestFromStudent({
    required String requestId, // Now in format "studentId_courseId"
    required int studentId,
  }) async {
    try {
      final studentRequestsRef = requestsCollection.doc('$studentId');

      final doc = await studentRequestsRef.get();

      if (doc.exists) {
        // Document exists - append new numbers
        final currentData = doc.data() as Map<String, dynamic>;
        final currentRequests =
            List<Map<String, dynamic>>.from(currentData['requests'] ?? []);
        currentRequests.removeWhere(
          (element) {
        if(element['status'] != 'pending'){
          throw Exception('Can\'t Remove Course That Has Been Accepted or declined');
        }
            if (element['id'] == requestId) {
              return true;
            }
            return false;
          },
        );

        await studentRequestsRef.update({
          'requests': [...currentRequests], // Append new numbers
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Set simple test data
        throw Exception('No Student Found');
      }
    } catch (e) {
      throw Exception('Failed to remove request: ${e.toString()}');
    }
  }
}
