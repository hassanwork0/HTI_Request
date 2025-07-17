
class Course {
  final String name;
  final String id; 
  final int units;
  final String departmentCode;
  final String? electiveName;

  const Course({
    required this.name,
    required this.id,
    required this.units,
    required this.departmentCode,
    this.electiveName,
  }
  );
  
  @override
  String toString() {
    return "$name $id $units $departmentCode";
  }
}