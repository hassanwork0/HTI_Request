import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/core/routes/names.dart';
import 'package:tables/features/morshed_app/data/models/morshed_model.dart';
import 'package:tables/features/morshed_app/data/models/request_model.dart';
import 'package:tables/features/student_app/data/models/course_model.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/widgets/profile/buildTree/build_tree.dart';
import 'package:tables/features/student_app/presentation/widgets/search_bar.dart';

class MorshedHomeScreen extends StatefulWidget {
  final MorshedModel currentMorshed;
  final List<StudentModel> students;

  const MorshedHomeScreen({
    super.key,
    required this.currentMorshed,
    required this.students,
  });

  @override
  State<MorshedHomeScreen> createState() => _MorshedHomeScreenState();
}

class _MorshedHomeScreenState extends State<MorshedHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _studentSearchController =
      TextEditingController();

  String? _selectedStatusFilter;
  final Map<String, List<RequestModel>> _studentRequests = {};
  RequestStats? _stats;
  bool _isLoading = true;
  bool _showSearchResults = false;
  bool _showByCourses = false; // New state for toggle between views
  List<StudentModel> _filteredStudents = [];
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();

    _filteredStudents = widget.students.where((student) {
      return student.morshedDr.id ==
          (widget.currentMorshed.doctorId ?? widget.currentMorshed.id);
    }).toList();

    _studentSearchController.addListener(_filterStudents);
    _setupRequestsListener();
    _fetchStats();
  }

  void _setupRequestsListener() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();

    for (final student in _filteredStudents) {
      final sub = _firestore
          .collection('requests')
          .doc('${student.id}')
          .snapshots()
          .listen((doc) {
        if (doc.exists) {
          final requestsData = doc.data()?['requests'] as List<dynamic>? ?? [];
          final studentRequests = requestsData
              .map((r) => RequestModel.fromJson(r as Map<String, dynamic>))
              .where((r) => r.morshedId == (widget.currentMorshed.doctorId ?? widget.currentMorshed.id))
              .toList();

          setState(() {
            _studentRequests['${student.id}'] = studentRequests;
            _fetchStats();
          });
        } else {
          setState(() {
            _studentRequests['${student.id}'] = [];
          });
        }
      });
      _subscriptions.add(sub);
    }
  }

  Future<void> _fetchStats() async {
    try {
      int total = 0;
      int pending = 0;
      int accepted = 0;
      int rejected = 0;

      _studentRequests.forEach((_, requests) {
        total += requests.length;
        pending += requests.where((r) => r.status == 'pending').length;
        accepted += requests.where((r) => r.status == 'accepted').length;
        rejected += requests.where((r) => r.status == 'rejected').length;
      });

      setState(() {
        _stats = RequestStats(
          totalRequests: total,
          pendingCount: pending,
          acceptedCount: accepted,
          rejectedCount: rejected,
        );
        _isLoading = false;
      });
    } catch (e) {
      _showSnackbar('Error fetching stats: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterStudents() {
    final query = _studentSearchController.text.trim().toLowerCase();
    setState(() {
      _filteredStudents = widget.students.where((student) {
        final matchesDoctor = student.morshedDr.id ==
            (widget.currentMorshed.doctorId ?? widget.currentMorshed.id);
        if (!matchesDoctor) return false;

        if (query.isEmpty) return true;

        final name = student.name.toLowerCase();
        final id = '${student.id}'.toLowerCase();
        return name.contains(query) || id.contains(query);
      }).toList();
    });
    _setupRequestsListener();
  }

  List<MapEntry<String, List<RequestModel>>> _getFilteredRequests() {
    final query = _searchController.text.trim().toLowerCase();
    return _studentRequests.entries.where((entry) {
      final requests = entry.value;
      return requests.any((request) {
        final matchesStatus = _selectedStatusFilter == null ||
            request.status == _selectedStatusFilter;
        final matchesSearch = query.isEmpty ||
            request.id.toLowerCase().contains(query) ||
            entry.key.contains(query) ||
            request.course.toString().toLowerCase().contains(query);
        return matchesStatus && matchesSearch;
      });
    }).toList();
  }

  Map<String, List<RequestModel>> _getCoursesWithStudents() {
    final coursesMap = <String, List<RequestModel>>{};
    
    _studentRequests.forEach((studentId, requests) {
      for (final request in requests) {
        final courseKey = '${request.course.id}-${request.course.name}';
        if (!coursesMap.containsKey(courseKey)) {
          coursesMap[courseKey] = [];
        }
        coursesMap[courseKey]!.add(request);
      }
    });
    
    return coursesMap;
  }

  void _showSnackbar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
        showCloseIcon: true,
        closeIconColor: Colors.white,
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentMorshed');
    await prefs.remove('rememberedMorshedPassword');
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, RoutesName.login);
    }
  }

  Future<String?> _showRejectionReasonDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rejection Reason', style: GoogleFonts.poppins()),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Enter reason for rejection',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              } else {
                _showSnackbar('Please enter a reason');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                Text('Submit', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _searchController.dispose();
    _studentSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: _showSearchResults
            ? buildSearchBar(
                searchController: _studentSearchController,
                onChanged: (value) => _filterStudents(),
                onSearchToggled: (show) {
                  setState(() {
                    _showSearchResults = show;
                    if (!show) {
                      _studentSearchController.clear();
                      _filterStudents();
                    }
                  });
                },
                lang: Localization(false),
              )
            : Text(
                'Welcome, ${widget.currentMorshed.name}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
        actions: [
          if (!_showSearchResults)
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black87),
              onPressed: () {
                setState(() {
                  _showSearchResults = !_showSearchResults;
                  if (!_showSearchResults) {
                    _studentSearchController.clear();
                    _filterStudents();
                  }
                });
              },
            ),
          if (!_showSearchResults)
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              onPressed: _logout,
            ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: width * 0.9,
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(16),
            child: _showSearchResults
                ? buildSearchResults(_filteredStudents, Localization(false))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_stats != null)
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem('Total', _stats!.totalRequests),
                                _buildStatItem('Pending', _stats!.pendingCount),
                                _buildStatItem(
                                    'Accepted', _stats!.acceptedCount),
                                _buildStatItem(
                                    'Rejected', _stats!.rejectedCount),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                labelText: 'Search Requests',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (value) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 8),
                          DropdownButton<String?>(
                            value: _selectedStatusFilter,
                            hint: Text('Filter', style: GoogleFonts.poppins()),
                            items: [
                              const DropdownMenuItem<String?>(
                                value: null,
                                child: Text('All'),
                              ),
                              ...['pending', 'accepted', 'rejected']
                                  .map((status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(
                                          status.capitalize(),
                                          style: GoogleFonts.poppins(),
                                        ),
                                      )),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedStatusFilter = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _showByCourses = !_showByCourses;
                            });
                          },
                          icon: Icon(
                            _showByCourses
                                ? Icons.people_alt
                                : Icons.menu_book,
                          ),
                          label: Text(
                            _showByCourses
                                ? 'Show By Students'
                                : 'Show By Courses',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _studentRequests.isEmpty
                                ? Center(
                                    child: Text(
                                      'No requests found',
                                      style: GoogleFonts.poppins(fontSize: 16),
                                    ),
                                  )
                                : _showByCourses
                                    ? _buildCoursesView()
                                    : _buildStudentsView(),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }


// In your _buildStudentsView widget, modify the ListTile to include the button and bulk actions:
Widget _buildStudentsView() {
  return ListView.builder(
    itemCount: _getFilteredRequests().length,
    itemBuilder: (context, index) {
      final entry = _getFilteredRequests()[index];
      final studentId = entry.key;
      final requests = entry.value;
      final student = _filteredStudents.firstWhere(
        (s) => '${s.id}' == studentId,
        orElse: () => widget.students.firstWhere(
          (s) => '${s.id}' == studentId,
        ),
      );

      // Filter pending requests for this student
      final pendingRequests = requests.where((r) => r.status == 'pending').toList();

      return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      child: ExpansionTile(
            title: Column(
          children: [
            ListTile(
              title: Text(
                '${student.name} (${student.id})',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: pendingRequests.isNotEmpty
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          tooltip: 'Accept all',
                          onPressed: () => _bulkRespondToRequests(
                            studentId, 
                            pendingRequests, 
                            'accepted'
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          tooltip: 'Reject all',
                          onPressed: () => _bulkRespondToRequests(
                            studentId, 
                            pendingRequests, 
                            'rejected'
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                onPressed: () => buildCourseTreePopup(context, student),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  'View Course Tree',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),]),
            children: [
              Text(
                  '${requests[0].comment}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),),
            ...requests.map((request) => ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Course: ${request.course.name}',
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    'Code: ${request.course.id}',
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    'Units: ${request.course.units}',
                    style: GoogleFonts.poppins(),
                  ),
                  _buildRegisteredCount(request.course),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status: ${request.status.capitalize()}',
                    style: GoogleFonts.poppins(),
                  ),
                  if (request.rejectionReason != null)
                    Text(
                      'Reason: ${request.rejectionReason}',
                      style: GoogleFonts.poppins(
                        color: Colors.redAccent,
                      ),
                    ),
                ],
              ),
            ))]),
      );
    },
  );
}

// Add this new method for bulk actions
Future<void> _bulkRespondToRequests(
  String studentId, 
  List<RequestModel> requests, 
  String status
) async {
  try {
    String? rejectionReason;
    if (status == 'rejected') {
      rejectionReason = await _showRejectionReasonDialog();
      if (rejectionReason == null) return;
    }

    final docRef = _firestore.collection('requests').doc(studentId);
    final doc = await docRef.get();

    if (doc.exists) {
      final requestsData = doc.data()?['requests'] as List<dynamic>? ?? [];
      final updatedRequests = requestsData
          .map((r) => RequestModel.fromJson(r as Map<String, dynamic>))
          .toList();

      for (final request in requests) {
        final requestIndex = updatedRequests.indexWhere((r) => r.id == request.id);
        if (requestIndex != -1) {
          updatedRequests[requestIndex].status = status;
          updatedRequests[requestIndex].rejectionReason = rejectionReason;
        }
      }

      await docRef.update({
        'requests': updatedRequests.map((r) => r.toJson()).toList(),
      });

      _showSnackbar(
        status == 'accepted' 
          ? 'All requests accepted successfully' 
          : 'All requests rejected successfully', 
        isError: false
      );
    } else {
      _showSnackbar('Student requests document not found');
    }
  } catch (e) {
    _showSnackbar('Error updating requests: $e');
  }
}


  Widget _buildCoursesView() {
    final coursesMap = _getCoursesWithStudents();
    final courseEntries = coursesMap.entries.toList();

    return ListView.builder(
      itemCount: courseEntries.length,
      itemBuilder: (context, index) {
        final entry = courseEntries[index];
        final courseKey = entry.key;
        final courseId = courseKey.split('-')[0];
        final courseName = courseKey.split('-')[1];
        final requests = entry.value;

        // Get the first request to get course details (assuming all requests for this course have same details)
        final sampleRequest = requests.first;
        
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExpansionTile(
            title: Text(
              '$courseName ($courseId)',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: _buildRegisteredCount(sampleRequest.course),
            children: requests.map((request) {
              final student = _filteredStudents.firstWhere(
                (s) => s.id == request.student,
                orElse: () => widget.students.firstWhere(
                  (s) => s.id == request.student,
                ),
              );

              return ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  '${student.name} (${student.id})',
                  style: GoogleFonts.poppins(),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status: ${request.status.capitalize()}',
                      style: GoogleFonts.poppins(),
                    ),
                    if (request.rejectionReason != null)
                      Text(
                        'Reason: ${request.rejectionReason}',
                        style: GoogleFonts.poppins(
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildRegisteredCount(CourseModel course) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('requests').snapshots(),
      builder: (context, snapshot) {
        int registeredCount = 0;
        
        if (snapshot.hasData) {
          for (var doc in snapshot.data!.docs) {
            var requests = doc['requests'] as List?;
            if (requests != null) {
              for (var request in requests) {
                if (request['course']['id'] == course.id && request['status'] != 'rejected') {
                  registeredCount++;
                }
              }
            }
          }
        }
        
        return Text(
          'Registered students: $registeredCount',
          style: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.blue.shade700,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12),
        ),
      ],
    );
  }
}

class RequestStats {
  final int totalRequests;
  final int pendingCount;
  final int acceptedCount;
  final int rejectedCount;

  RequestStats({
    required this.totalRequests,
    required this.pendingCount,
    required this.acceptedCount,
    required this.rejectedCount,
  });
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}