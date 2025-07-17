import 'package:tables/data/departments/department.dart';

abstract class BaseMorshed {
  String get id;
  String get name;
  Department get department;
  String? get profileImageUrl;


}
