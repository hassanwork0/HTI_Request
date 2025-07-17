import 'package:tables/data/departments/department.dart';
import 'package:tables/features/morshed_app/domain/entities/base_morshed.dart';
import 'package:tables/features/morshed_app/domain/entities/morshed_dr.dart';
import 'package:tables/features/morshed_app/domain/entities/morshed_eng.dart';

class MorshedModel implements BaseMorshed {
  @override
  final String id;
  @override
  final String name;
  @override
  final Department department;
  @override
  final String? profileImageUrl;
  final String? doctorId; // Null for doctors
  
  MorshedModel({
    required this.id,
    required this.name,
    required this.department,
    this.profileImageUrl,
    this.doctorId,
  });
    factory MorshedModel.fromJson(Map<String, dynamic> json) {
    return MorshedModel(
      id: json['id'] as String,
      name: json['name'] as String,
      department: Department.fromJson(json['department']),
      profileImageUrl: json['profileImageUrl'] as String?,
      doctorId: json['doctor_id'] as String?,
    );
  }
  
  factory MorshedModel.fromDr(MorshedDr dr) {
    return MorshedModel(
      id: dr.id,
      name: dr.name,
      department: dr.department,
      profileImageUrl: dr.profileImageUrl,
    );
  }
  
  factory MorshedModel.fromEng(MorshedEng eng) {
    return MorshedModel(
      id: eng.id,
      name: eng.name,
      department: eng.department,
      profileImageUrl: eng.profileImageUrl,
      doctorId: eng.doctorId,
    );
  }
  
  bool get isEngineer => doctorId != null;
  
  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'name': name,
      'department': department.toJson(),
      'profileImageUrl': profileImageUrl,
    };
    
    if (isEngineer) {
      json['doctor_id'] = doctorId;
    }
    
    return json;
  }
}