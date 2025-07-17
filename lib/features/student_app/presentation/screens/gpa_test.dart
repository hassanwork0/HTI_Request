import 'package:flutter/material.dart';
import 'package:tables/data/departments/electrical.dart';
import 'package:tables/features/student_app/data/models/course_model.dart';
import '../../domain/entities/student.dart';

class GpaTestScreen extends StatefulWidget {
  final Student student;

  const GpaTestScreen({super.key, required this.student});

  @override
  State<GpaTestScreen> createState() => _GpaTestScreenState();
}

class _GpaTestScreenState extends State<GpaTestScreen> {
  List<CourseModel> allCourses = [];

  List<CourseGrade> selectedCourses = [];
  double currentGPA = 0.0;
  double currentCredits = 0;
  double projectedGPA = 0.0;
  CourseModel? _selectedCourse;
  String? _selectedGrade;

  @override
  void initState() {
    super.initState();

    allCourses = Electrical().allCoursesList.where(
      (course) {
        bool found = false;
        for (var studentCourse in widget.student.coursesFinished) {
          studentCourse.id == course.id ? found = true : false;
          if(found) {
            break;
          }
        }
        return !found;
      },
    ).toList();

    currentGPA = widget.student.gpa;
    currentCredits = widget.student.units;
    projectedGPA = currentGPA;
  }

  void _addCourse(CourseModel course, String grade) {
    setState(() {
      selectedCourses.add(CourseGrade(course: course, grade: grade));
    });
  }

  void _calculateProjectedGPA() {
    double totalPoints = currentGPA * currentCredits;
    double totalCredits = currentCredits;

    for (var courseGrade in selectedCourses) {
      totalPoints +=
          _gradeToValue(courseGrade.grade) * courseGrade.course.units;
      totalCredits += courseGrade.course.units;
    }

    setState(() {
      projectedGPA = totalCredits > 0 ? totalPoints / totalCredits : currentGPA;
    });
  }

  double _gradeToValue(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return 4.0;
      case 'A-':
        return 3.7;
      case 'B+':
        return 3.3;
      case 'B':
        return 3.0;
      case 'B-':
        return 2.7;
      case 'C+':
        return 2.3;
      case 'C':
        return 2.0;
      case 'C-':
        return 1.7;
      case 'D+':
        return 1.3;
      case 'D':
        return 1.0;
      case 'D-':
        return 0.7;
      case 'F':
        return 0.0;
      default:
        return 0.0;
    }
  }

  double _calculateProjectedCredits() {
    return currentCredits +
        selectedCourses.fold(
            0, (sum, courseGrade) => sum + courseGrade.course.units);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPA Calculator'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current GPA Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Current Academic Status',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem('GPA', currentGPA.toStringAsFixed(2)),
                        _buildStatItem('Credits', '$currentCredits'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Projected GPA Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      // ignore: deprecated_member_use
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      // ignore: deprecated_member_use
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Projected GPA',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                projectedGPA.toStringAsFixed(2),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _getGpaColor(projectedGPA),
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      // ignore: deprecated_member_use
                                      color: Colors.black.withOpacity(0.2),
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Projected Credits',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                '${_calculateProjectedCredits()}',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      // ignore: deprecated_member_use
                                      color: Colors.black.withOpacity(0.2),
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Course Input Section
            Text(
              'Add Courses to Calculate',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Selected Courses List
            ...selectedCourses
                .map((courseGrade) => _buildCourseGradeItem(courseGrade))
                ,

            const SizedBox(height: 12),

            // Add Course Row
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Autocomplete<CourseModel>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<CourseModel>.empty();
                      }
                      return allCourses.where((course) {
                        return course.name.toLowerCase().contains(
                                textEditingValue.text.toLowerCase()) ||
                            course.id
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    displayStringForOption: (CourseModel course) =>
                        '${course.id} - ${course.name}',
                    fieldViewBuilder: (
                      BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted,
                    ) {
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Course',
                          hintText: 'Type course name or ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                    onSelected: (CourseModel selection) {
                      setState(() {
                        _selectedCourse = selection;
                      });
                    },
                    optionsViewBuilder: (
                      BuildContext context,
                      AutocompleteOnSelected<CourseModel> onSelected,
                      Iterable<CourseModel> options,
                    ) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: SizedBox(
                            height: 200.0,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final CourseModel option =
                                    options.elementAt(index);
                                return InkWell(
                                  onTap: () => onSelected(option),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child:
                                        Text('${option.id} - ${option.name}'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _selectedGrade,
                    decoration: InputDecoration(
                      labelText: 'Grade',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    menuMaxHeight: 200,
                    alignment: AlignmentDirectional.bottomCenter,
                    items: [
                      'A+',
                      'A',
                      'A-',
                      'B+',
                      'B',
                      'B-',
                      'C+',
                      'C',
                      'C-',
                      'D+',
                      'D',
                      'D-',
                      'F'
                    ]
                        .map((String grade) => DropdownMenuItem<String>(
                              value: grade,
                              child: Text(grade),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGrade = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: Icon(Icons.add_circle,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: (_selectedCourse != null && _selectedGrade != null)
                      ? () {
                          _addCourse(_selectedCourse!, _selectedGrade!);
                          setState(() {
                            _selectedCourse = null;
                            _selectedGrade = null;
                          });
                        }
                      : null,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calculate'),
                    onPressed: selectedCourses.isNotEmpty
                        ? _calculateProjectedGPA
                        : null,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color:
                    label == 'GPA' ? _getGpaColor(double.parse(value)) : null,
              ),
        ),
      ],
    );
  }

  Widget _buildCourseGradeItem(CourseGrade courseGrade) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          // ignore: deprecated_member_use
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(courseGrade.course.name),
        subtitle: Text(
            '${courseGrade.course.id} • ${courseGrade.course.units} units'),
        trailing: Chip(
          label: Text(
            courseGrade.grade,
            style: TextStyle(
              color: _getGradeColor(courseGrade.grade),
              fontWeight: FontWeight.bold,
            ),
          ),
          // ignore: deprecated_member_use
          backgroundColor: _getGradeColor(courseGrade.grade).withOpacity(0.1),
        ),
      ),
    );
  }

  Color _getGpaColor(double gpa) {
    if (gpa >= 3.5) return Colors.green;
    if (gpa >= 2.5) return Colors.orange;
    return Colors.red;
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
        return Colors.green;
      case 'A':
        return Colors.green;
      case 'A-':
        return Colors.lightGreen;
      case 'B+':
        return Colors.blue;
      case 'B':
        return Colors.blue;
      case 'B-':
        return Colors.lightBlue;
      case 'C+':
        return Colors.orange;
      case 'C':
        return Colors.orange;
      case 'D+':
        return Colors.red;
      case 'D':
        return Colors.red;
      case 'F':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class CourseGrade {
  CourseModel course;
  String grade;

  CourseGrade({
    required this.course,
    required this.grade,
  });
}
