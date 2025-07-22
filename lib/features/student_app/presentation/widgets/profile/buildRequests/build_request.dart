import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tables/features/morshed_app/data/models/request_model.dart';
import 'package:tables/features/morshed_app/data/sources/request_remote_data.dart';
import 'package:tables/features/student_app/data/models/course_model.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/widgets/profile/buildTree/build_tree.dart';

void buildCourseRegistrationPopup(BuildContext context, StudentModel student) {
  final requestsRepo = RequestRemoteData();
  final searchController = TextEditingController();

  List<CourseModel> allCourses = student.department.allCoursesList
      .where((course) => !student.coursesFinished.any((c) => c.id == course.id))
      .toList();

  showDialog(
    context: context,
    builder: (context) {
      return FutureBuilder<List<RequestModel>>(
        future: requestsRepo.getStudentRequests(student: student),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to load requests: ${snapshot.error}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          }

          return _CourseRegistrationContent(
            initialRequests: snapshot.data ?? [],
            allCourses: allCourses,
            student: student,
            searchController: searchController,
          );
        },
      );
    },
  );
}

class _CourseRegistrationContent extends StatefulWidget {
  final List<RequestModel> initialRequests;
  final List<CourseModel> allCourses;
  final StudentModel student;
  final TextEditingController searchController;

  const _CourseRegistrationContent({
    required this.initialRequests,
    required this.allCourses,
    required this.student,
    required this.searchController,
  });

  @override
  State<_CourseRegistrationContent> createState() =>
      _CourseRegistrationContentState();
}

class _CourseRegistrationContentState
    extends State<_CourseRegistrationContent> {
  late List<RequestModel> _requests;
  final requestsRepo = RequestRemoteData();
  final Set<String> _selectedCourses = {};
  bool _hasSentRequests = false;
  int runits = 0;
  @override
  void initState() {
    super.initState();
    _requests = widget.initialRequests;
    _hasSentRequests = _requests.any((r) => r.student == widget.student.id);
  }

  Future<void> _refreshRequests() async {
    final updatedRequests =
        await requestsRepo.getStudentRequests(student: widget.student);
    setState(() {
      _requests = updatedRequests;
      _hasSentRequests = _requests.any((r) => r.student == widget.student.id);
    });
  }

  Set<String> get _studentRegisteredCourseIds => _requests
      .where((r) => r.student == widget.student.id)
      .map((r) => r.course.id)
      .toSet();

  @override
  Widget build(BuildContext context) {
    final commentController = TextEditingController();
    final searchQuery = widget.searchController.text.toLowerCase();
    final filteredCourses = widget.allCourses.where((course) {
      return course.name.toLowerCase().contains(searchQuery) ||
          course.id.toLowerCase().contains(searchQuery);
    }).toList();

    return AlertDialog(
      title: Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _refreshRequests,
                ),
              ),
              if(!_hasSentRequests)
              Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'units :$runits',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )),
              Align(
                alignment: Alignment.topRight,
                child: _buildStatusIndicator(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.searchController,
            decoration: InputDecoration(
              hintText: 'Search courses...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_selectedCourses.isNotEmpty) ...[
                const Text(
                  'Selected Courses',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ..._selectedCourses.map((courseId) {
                  final course =
                      widget.allCourses.firstWhere((c) => c.id == courseId);
                  return _buildSelectedCourseCard(context, course);
                }),
                const Divider(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter your comment...',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey[300]!, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _hasSentRequests
                          ? null
                          : () => _sendSelectedCourses(
                              context, commentController.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Send Requests',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Divider(),
                    ElevatedButton(
                      onPressed: _hasSentRequests
                          ? null
                          : () => buildCourseTreePopup(context, widget.student),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'View Tree',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
              if (_studentRegisteredCourseIds.isNotEmpty) ...[
                //This Almost got me a heart attack
                const Text(
                  'Your Requested Courses',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ..._studentRegisteredCourseIds.map((courseId) {
                  final course =
                      widget.allCourses.firstWhere((c) => c.id == courseId);
                  return _buildAvailableCourseCard(context, course, true);
                }),
                const Divider(),
              ],
              const Text(
                'Available Courses',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              if (filteredCourses.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No courses found'),
                )
              else
                ...filteredCourses
                    .where((course) =>
                        !_studentRegisteredCourseIds.contains(course.id) &&
                        !_selectedCourses.contains(course.id))
                    .map((course) {
                  return _buildAvailableCourseCard(
                    context,
                    course,
                    _hasSentRequests,
                  );
                }),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.student.currentCourses = [];
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    Color? statusColor;
    if (_hasSentRequests) {
      bool hasPending = _requests.any((r) {
        return (r.student == widget.student.id) && r.status == 'pending';
      });

      bool hasAccepted = _requests.any((r) {
        return (r.student == widget.student.id) && r.status == 'accepted';
      });

      if (hasPending) {
        statusColor = Colors.orange;
      } else if (hasAccepted) {
        statusColor = Colors.green;
      } else {
        statusColor = Colors.red;
      }
    }

    return Container(
      width: 16,
      height: 16,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: statusColor ?? Colors.transparent,
        border: statusColor != null
            ? Border.all(color: Colors.grey[300]!, width: 1)
            : null,
      ),
    );
  }

  Widget _buildSelectedCourseCard(BuildContext context, CourseModel course) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Code: ${course.id} | Units: ${course.units}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () {
                setState(() {
                  _selectedCourses.remove(course.id);
                  widget.student.currentCourses.remove(course);
                  runits = 0;
                  for (CourseModel c in widget.student.currentCourses) {
                    runits += c.units;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  bool exceedUnits() {
    int validUnits;
    if (widget.student.gpa >= 3) {
      validUnits = 21;
    } else if (widget.student.gpa >= 2) {
      validUnits = 18;
    } else if (widget.student.gpa >= 1) {
      validUnits = 14;
    } else {
      validUnits = 12;
    }

    return runits > validUnits;
  }

  Widget _buildAvailableCourseCard(
    BuildContext context,
    CourseModel course,
    bool isDisabled,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Code: ${course.id} | Units: ${course.units}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('requests').snapshots(),
              builder: (context, snapshot) {
                int registeredCount = 0;
                String? rejectionReason;

                if (snapshot.hasData) {
                  for (var doc in snapshot.data!.docs) {
                    var requests = doc['requests'] as List?;
                    if (requests != null) {
                      for (var request in requests) {
                        if (request['course']['id'] == course.id) {
                          if (request['status'] != 'rejected') {
                            registeredCount++;
                          } else if (request['rejectionReason'] != null) {
                            rejectionReason = request['rejectionReason'];
                          }
                        }
                      }
                    }
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registered students: $registeredCount',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    if (rejectionReason != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Rejection reason: $rejectionReason',
                          style: TextStyle(
                            color: Colors.red[600],
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: isDisabled
                  ? Container()
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          runits += course.units;
                          if (exceedUnits()) {
                            runits -= course.units;
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Units Limit Exceed",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Close"),
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          }
                          _selectedCourses.add(course.id);
                          widget.student.currentCourses.add(course);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[100],
                        foregroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Select'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendSelectedCourses(
      BuildContext context, String comment) async {
    if (_selectedCourses.isEmpty) return;

    try {
      for (final courseId in _selectedCourses) {
        final course = widget.allCourses.firstWhere((c) => c.id == courseId);
        final newRequest = RequestModel(
          id: '',
          student: widget.student.id,
          course: course,
          morshedId: widget.student.morshedDr.id,
          morshedDr: widget.student.morshedDr.name,
          morshedEng: widget.student.morshedEng.name,
          isSummer: false,
          status: 'pending',
        );

        await requestsRepo.sendRequest(
          student: widget.student,
          request: newRequest,
          optComment: comment,
        );

        widget.student.currentCourses = [];
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course requests sent successfully')),
      );

      setState(() {
        _selectedCourses.clear();
        _hasSentRequests = true;
      });

      await _refreshRequests();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send requests: ${e.toString()}')),
      );
    }
  }
}
