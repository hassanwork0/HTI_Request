import 'package:tables/data/departments/department.dart';
import 'package:tables/features/morshed_app/domain/entities/base_morshed.dart';

class MorshedDr implements BaseMorshed {
  @override
  final String id;
  @override
  final String name;
  @override
  final Department department;
  @override
  final String? profileImageUrl;
  
  MorshedDr({
    required this.id,
    required this.name,
    required this.department,
    this.profileImageUrl,
  });

}

