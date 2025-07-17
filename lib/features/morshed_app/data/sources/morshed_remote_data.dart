import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tables/data/departments/department.dart';
import 'package:tables/features/morshed_app/data/models/morshed_model.dart';
import 'package:tables/features/morshed_app/domain/entities/morshed_dr.dart';
import 'package:tables/features/morshed_app/domain/entities/morshed_eng.dart';
import 'package:tables/features/morshed_app/domain/repositories/morshed_repository.dart';

class MorshedRemoteData extends MorshedRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _drsCollection => _firestore.collection('doctors');
  CollectionReference get _engsCollection => _firestore.collection('engineers');
  CollectionReference get requestsCollection => _firestore.collection('requests');


  @override
  Future<MorshedModel> getMorshed(String morshedName, String morshedPassword) async {
    try {
      // Search doctors collection by login_name
      final drSnapshot = await _drsCollection
          .where('login_name', isEqualTo: morshedName)
          .get();

      for (final doc in drSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        // Check password
        if (data['password'] == morshedPassword) {

          return MorshedModel.fromDr(
            MorshedDr(
            id: data['id'].toString(), // Convert number to string
            name: data['name'] ?? '',
            department: Department.fromJson(data['department']),
            profileImageUrl: data['profileImageUrl'],
          ));
        }
      }

      // Search engineers collection by login_name
      final engSnapshot = await _engsCollection
          .where('login_name', isEqualTo: morshedName)
          .get();

      for (final doc in engSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        // Check password
        if (data['password'] == morshedPassword) {
          // print('Engineer data: $data'); // Debug: Print document data
          return MorshedModel.fromEng(MorshedEng(
            id: data['id'].toString(), // Convert number to string
            name: data['name'] ?? '',
            department: Department.fromJson(data['department']),
            profileImageUrl: data['profileImageUrl'],
            doctorId: data['doctor_id'].toString(),
          ));
        }
      }

      throw Exception('Morshed not found or invalid credentials');
    } catch (e) {
      throw Exception('Failed to get morshed: ${e.toString()}');
    }
  }

  // searchMorsheds remains unchanged
  @override
  Future<List<MorshedModel>> searchMorsheds(String query) async {
    try {
      // Search in doctors collection
      final drSnapshot = await _drsCollection
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      // Search in engineers collection
      final engSnapshot = await _engsCollection
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      // Combine and convert results to MorshedModel
      final List<MorshedModel> morsheds = [];

      // Process doctors
      morsheds.addAll(drSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return MorshedModel.fromDr(MorshedDr(
          id: doc.id,
          name: data['name'] ?? '',
          department: Department.fromJson(data['department']),
          profileImageUrl: data['profileImageUrl'],
        ));
      }));

      // Process engineers
      morsheds.addAll(engSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return MorshedModel.fromEng(MorshedEng(
          id: doc.id,
          name: data['name'] ?? '',
          department: Department.fromJson(data['department']),
          profileImageUrl: data['profileImageUrl'],
          doctorId: data['doctor_id'] ?? '',
        ));
      }));

      return morsheds;
    } catch (e) {
      throw Exception('Failed to search morsheds: ${e.toString()}');
    }
  }
}