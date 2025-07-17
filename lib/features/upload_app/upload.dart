import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/data/departments/department.dart';
import 'package:tables/data/departments/electrical.dart';
import 'package:tables/features/morshed_app/data/models/morshed_model.dart';
import 'package:tables/features/morshed_app/domain/entities/morshed_dr.dart';
import 'package:tables/features/morshed_app/domain/entities/morshed_eng.dart';
import 'package:tables/features/student_app/data/models/course_model.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/widgets/search_bar.dart';
import 'package:tables/features/upload_app/dummy_data.dart';

class UploadStudentsScreen extends StatefulWidget {
  const UploadStudentsScreen({super.key});

  @override
  State<UploadStudentsScreen> createState() => _UploadStudentsScreenState();
}

class _UploadStudentsScreenState extends State<UploadStudentsScreen> {
  bool _isUploading = false;
  int _successCount = 0;
  int _failureCount = 0;
  int _backupNumber = 0;
  String _currentStatus = 'Ready to upload';
  double _progress = 0;
  final TextEditingController _studentDataController = TextEditingController();
  List<StudentModel> _studentsToUpload = [];
  final TextEditingController _courseDataController = TextEditingController();

  Future<int> _getLatestBackupNumber() async {
    final firestore = FirebaseFirestore.instance;
    final doc =
        await firestore.collection('backup_metadata').doc('count').get();
    if (doc.exists) {
      return doc.data()?['latest'] ?? 0;
    }
    return 0;
  }

  Future<void> _updateBackupCount(int number) async {
    await FirebaseFirestore.instance
        .collection('backup_metadata')
        .doc('count')
        .set({'latest': number});
  }

  Future<void> _createBackup() async {
    final latest = await _getLatestBackupNumber();
    _backupNumber = latest + 1;

    setState(() {
      _currentStatus = 'Creating backup...';
      _progress = 0;
    });

    final firestore = FirebaseFirestore.instance;
    _backupNumber = await _getLatestBackupNumber() + 1;
    final backupCol = firestore.collection('backup_$_backupNumber');
    final studentsCol = firestore.collection('students');
    final snapshot = await studentsCol.get();

    final batch = firestore.batch();
    int processed = 0;
    final total = snapshot.docs.length;

    for (final doc in snapshot.docs) {
      batch.set(backupCol.doc(doc.id), doc.data());
      processed++;

      if (processed % 100 == 0 || processed == total) {
        setState(() {
          _progress = processed / total;
          _currentStatus = 'Backing up $processed/$total';
        });
      }
      await _updateBackupCount(_backupNumber);
    }

    await batch.commit();
    setState(() {
      _progress = 1;
      _currentStatus = 'Backup $_backupNumber created';
    });
  }

  List<StudentModel> _parseStudentData(String studentText, String courseText) {
    final lines = studentText.split('\n');
    final courseLines = courseText.split('\n');
    final students = <StudentModel>[];
    final courseMap = <int, List<Map<String, String>>>{};

     // First parse all course data into a map by student ID
    for (final line in courseLines) {
      if (line.trim().isEmpty) continue;
      
      try {
        final parts = line.split('\t');
        if (parts.length < 3) continue;
        
        final studentId = int.parse(parts[0].trim());
        final courseCode = parts[1].trim();
        final grade = parts[2].trim().toUpperCase();
        
        if (!courseMap.containsKey(studentId)) {
          courseMap[studentId] = [];
        }
        courseMap[studentId]!.add({
          'code': courseCode,
          'grade': grade,
        });
      } catch (e) {
        debugPrint('Error parsing course line: $line\nError: $e');
      }
    }


  // Map Arabic numerals to English
  const arabicToEnglish = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };

  for (final line in lines) {
    if (line.trim().isEmpty) continue;

    try {
      final parts = line.split('\t');
      if (parts.length < 6) continue;

      final id = int.parse(parts[0].trim());
      final name = parts[1].trim();
      
      // Handle Arabic numerals in units
      String unitsStr = parts[2].trim();
      if (unitsStr.contains(RegExp(r'[٠-٩]'))) {
        unitsStr = unitsStr.split('').map((c) => arabicToEnglish[c] ?? c).join();
      }
      final units = double.parse(unitsStr);

      // Handle Arabic numerals in GPA (just in case)
      String gpaStr = parts[3].trim();
      if (gpaStr.contains(RegExp(r'[٠-٩]'))) {
        gpaStr = gpaStr.split('').map((c) => arabicToEnglish[c] ?? c).join();
      }
      final gpa = double.parse(gpaStr);

      final morshedDrName = parts[4].trim();
      final morshedEngName = parts[5].trim();

      MorshedModel? morshedDr;
      for (final entry in Data().morshedDrs.entries) {
        if (entry.value['name'] == morshedDrName) {
          morshedDr = MorshedModel.fromDr(MorshedDr(
            id: '${entry.key}',
            name: entry.value['name'],
            department: Department.fromJson(entry.value['department']),
          ));
          break;
        }
      }

      MorshedModel? morshedEng;
      for (final entry in Data().morshedEngs.entries) {
        if (entry.value['name'] == morshedEngName) {
          morshedEng = MorshedModel.fromEng(
            MorshedEng(
              doctorId: '${entry.value['doctor_id']}',
              id: '${entry.key}',
              name: entry.value['name'],
              department: Department.fromJson(entry.value['department']),
            ),
          );
          break;
        }
      }

      if (morshedDr == null || morshedEng == null) {
        debugPrint('Could not find morshed for student $id');
        continue;
      }
      
       // Process courses for this student
        final finishedCourses = <CourseModel>[];
        final failedCourses = <CourseModel>[];
        
        if (courseMap.containsKey(id)) {
          for (final courseData in courseMap[id]!) {
            final course = Data().getCourse(courseData['code']!, Electrical());
            final grade = courseData['grade']!;
            
            if (grade == 'F' || grade == 'F-') {
              failedCourses.add(course);
            } else {
              finishedCourses.add(course);
            }
          }
        }

      final student = StudentModel(
        id: id,
        name: name,
        gpa: gpa,
        units: units,
        department: Electrical(),
        morshedDr: morshedDr,
        morshedEng: morshedEng,
        coursesFinished: finishedCourses,
        currentCourses: [],
        faildCourses: failedCourses,
      );

      students.add(student);
    } catch (e) {
      debugPrint('Error parsing line: $line\nError: $e');
    }
  }

  return students;
}

  Future<void> _showUploadConfirmationDialog() async {
    final searchController = TextEditingController();
    List<StudentModel> filteredStudents = List.from(_studentsToUpload);

    final shouldUpload = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void filterStudents(String query) {
              setState(() {
                filteredStudents = _studentsToUpload.where((student) {
                  final idMatch = student.id.toString().contains(query);
                  final nameMatch =
                      student.name.toLowerCase().contains(query.toLowerCase());
                  return idMatch || nameMatch;
                }).toList();
              });
            }

            return AlertDialog(
              title: const Text('Confirm Upload'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildSearchBar(
                    searchController: searchController,
                    onChanged: filterStudents,
                    onSearchToggled: (searching) => setState(() {}),
                    lang: Localization(false),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: buildSearchResults(
                      filteredStudents,
                      Localization(false),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('CONFIRM'),
                ),
              ],
            );
          },
        );
      },
    );

    if (shouldUpload == true) {
      await _performUpload();
    }
  }

  Future<void> _performUpload() async {
    setState(() {
      _isUploading = true;
      _successCount = 0;
      _failureCount = 0;
      _currentStatus = 'Uploading...';
      _progress = 0;
    });

    try {
      await _createBackup();

      final firestore = FirebaseFirestore.instance;
      final studentsCol = firestore.collection('students');
      final batch = firestore.batch();
      int processed = 0;
      final total = _studentsToUpload.length;

      for (final student in _studentsToUpload) {
        try {
          final studentData = student.toJson();
          studentData['coursesFinished'] =
              student.coursesFinished.map((c) => c.toJson()).toList();
          studentData['faildCourses'] =
              student.faildCourses.map((c) => c.toJson()).toList();
          studentData['currentCourses'] =
              student.currentCourses.map((c) => c.toJson()).toList();

          batch.set(
            studentsCol.doc('${student.id}'),
            studentData,
            SetOptions(merge: true),
          );
          _successCount++;
        } catch (e) {
          debugPrint('Error uploading student ${student.id}: ${e.toString()}');
          _failureCount++;
        }
        processed++;
        if (processed % 10 == 0 || processed == total) {
          setState(() {
            _progress = processed / total;
            _currentStatus = 'Uploading $processed/$total';
          });
        }
      }

      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Upload complete! $_successCount success, $_failureCount failures',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: _failureCount == 0 ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
        _currentStatus = 'Upload completed';
      });
    }
  }

  Future<void> _uploadStudents() async {
    if (_isUploading || _studentDataController.text.isEmpty) return;

    _studentsToUpload = _parseStudentData(_studentDataController.text , _courseDataController.text,);
    if (_studentsToUpload.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No valid student data found')),
      );
      return;
    }

    await _showUploadConfirmationDialog();
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Students'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Paste Student Data',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Format: ID\tName\tUnits\tGPA\tMorshedDr\tMorshedEng',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: TextField(
                          controller: _studentDataController,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText:
                                'Paste student data here (one per line)...',
                            contentPadding: EdgeInsets.all(10),
                          ),
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
           // Course Data Text Field
            Expanded(
              flex: 1,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Paste Course Data',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Format: StudentID\tCourseCode\tGrade',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: TextField(
                          controller: _courseDataController,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Paste course data here (one per line)...',
                            contentPadding: EdgeInsets.all(10),
                          ),
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upload Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.grey[200],
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _currentStatus,
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (_backupNumber > 0) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Backup: backup_$_backupNumber',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('Success', '$_successCount', Colors.green),
                _buildStatCard('Failures', '$_failureCount', Colors.orange),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadStudents,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isUploading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('Uploading...'),
                      ],
                    )
                  : const Text(
                      'UPLOAD STUDENTS',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _studentDataController.dispose();
    super.dispose();
  }
}

class MorshedUploader extends StatelessWidget {
  const MorshedUploader({super.key});

  // Function to upload morsheds to Firestore
  Future<void> _uploadMorsheds(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Upload doctors first
      await _uploadCollection(Data().morshedDrs, 'doctors');

      // Then upload engineers
      await _uploadCollection(Data().morshedEngs, 'engineers');

      // Hide loading indicator
      Navigator.of(context).pop();

      // Show success message
      _showSnackbar(context, 'All morsheds uploaded successfully!',
          isError: false);
    } catch (e) {
      // Hide loading indicator if still showing
      Navigator.of(context).pop();
      // Show error message
      _showSnackbar(context, 'Error uploading morsheds: $e');
    }
  }

  Future<void> _uploadCollection(
      Map<int, dynamic> data, String collectionName) async {
    final collection = FirebaseFirestore.instance.collection(collectionName);

    for (var entry in data.entries) {
      final docData = Map<String, dynamic>.from(entry.value);
      docData['id'] = entry.key;

      await collection
          .doc(entry.key.toString())
          .set(docData, SetOptions(merge: true));
    }
  }

  // Helper function to show Snackbar
  void _showSnackbar(BuildContext context, String message,
      {bool isError = true}) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Morshed Uploader',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Upload Morshed Data to Firestore',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _uploadMorsheds(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.cloud_upload, color: Colors.white),
              label: Text(
                'Upload All Morsheds',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildStatsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Summary',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            _buildStatRow('Total Doctors', Data().morshedDrs.length.toString()),
            _buildStatRow(
                'Total Engineers', Data().morshedEngs.length.toString()),
            _buildStatRow('Department', 'Telecom Engineering'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
