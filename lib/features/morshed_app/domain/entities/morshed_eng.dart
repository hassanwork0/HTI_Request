import 'package:tables/data/departments/department.dart';
import 'package:tables/features/morshed_app/domain/entities/base_morshed.dart';

class MorshedEng implements BaseMorshed {
  @override
  final String id;
  @override
  final String name;
  @override
  final Department department;
  @override
  final String? profileImageUrl;
  final String doctorId;
  
  MorshedEng({
    required this.id,
    required this.name,
    required this.department,
    required this.doctorId,
    this.profileImageUrl,
  });
  
}