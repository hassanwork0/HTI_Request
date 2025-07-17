import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tables/core/routes/names.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/presentation/widgets/switcher.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<StudentLoginScreen> {
  List<StudentModel> students = [];
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _isRegistering = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
    _checkRememberedUser();
  }

  Future<void> _checkRememberedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberedStudentJson = prefs.getString('currentStudent');
    
    if (rememberedStudentJson != null) {
      final studentMap = jsonDecode(rememberedStudentJson) as Map<String, dynamic>;
      setState(() {
        _idController.text = studentMap['id'].toString();
        _passwordController.text = prefs.getString('rememberedStudentPassword') ?? '';
        _rememberMe = true;
      });
    }
  }

  Future<void> _fetchStudents() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('students').get();
      final List<StudentModel> fetchedStudents = snapshot.docs.map((doc) {
        return StudentModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      setState(() {
        students.clear();
        students.addAll(fetchedStudents);
        _isLoading = false;
      });
    } catch (e) {
      _showSnackbar('Error loading students: $e');
    }
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

  Future<void> _saveRememberedUser(StudentModel student, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('currentStudent', jsonEncode(student.toJson()));
      await prefs.setString('rememberedStudentPassword', password);
    } else {
      await prefs.remove('currentStudent');
      await prefs.remove('rememberedStudentPassword');
    }
  }

  Future<void> _checkStudentAndSetMode() async {
    final id = _idController.text.trim();
    if (id.isEmpty) return;

    setState(() => _isLoading = true);
    
    try {
      final studentDoc = await _firestore.collection('students').doc(id).get();
      
      if (!studentDoc.exists) {
        _showSnackbar('No such student found!');
        return;
      }

      final hasPassword = studentDoc.data()?['password'] != null;
      setState(() => _isRegistering = !hasPassword);
      
      if (!hasPassword) {
        _showSnackbar('Please register by setting a password');
      }
    } catch (e) {
      _showSnackbar('Error checking student: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLoginOrRegister() async {
    final id = _idController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (id.isEmpty) {
      _showSnackbar('Please enter your ID!');
      return;
    }

    if (_isRegistering && password != confirmPassword) {
      _showSnackbar('Passwords do not match!');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final studentDoc = await _firestore.collection('students').doc(id).get();
      
      if (!studentDoc.exists) {
        _showSnackbar('No such student found!');
        return;
      }

      final studentExists = students.any((s) => '${s.id}' == id);
      if (!studentExists) {
        _showSnackbar('Student data not synchronized yet');
        await _fetchStudents();
        if (!context.mounted) return;
      }

      final currentStudent = students.firstWhere(
        (s) => '${s.id}' == id,
      );

      final storedPassword = studentDoc.data()?['password'];
      
      if (_isRegistering) {
        if (password.isEmpty || confirmPassword.isEmpty) {
          _showSnackbar('Please enter and confirm your password!');
          return;
        }
        // Register: Set password in Firestore
        await _firestore.collection('students').doc(id).update({
          'password': password,
        });
        _showSnackbar('Registration successful!', isError: false);
      } else {
        // Login: Verify password
        if (storedPassword == null || storedPassword != password) {
          _showSnackbar('Incorrect password!');
          return;
        }
      }

      // Save to SharedPreferences if remember me is checked
      await _saveRememberedUser(currentStudent, password);

      // Navigation
      if (context.mounted) {
        Navigator.pushReplacementNamed(
          context,
          RoutesName.studentHome,
          arguments: {
            'students': students,
            'isLoggedIn': true,
            'currentStudent': currentStudent,
          },
        );
      }
    } catch (e) {
      _showSnackbar('Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: switcher(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: height,
            child: Center(
              child: Container(
                width: width * 0.9,
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://i.imgur.com/Pr0QLYV.jpeg',
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        // Handle link tap
                      },
                      child: Text(
                        'hti-o.edu.eg',
                        style: GoogleFonts.poppins(
                          color: Colors.blue,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _idController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Student ID',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: _checkStudentAndSetMode,
                        ),
                      ),
                      onSubmitted: (_) => _checkStudentAndSetMode(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    if (_isRegistering) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                        ),
                        Text(
                          'Remember me',
                          style: GoogleFonts.poppins(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLoginOrRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                _isRegistering ? 'REGISTER' : 'LOGIN',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isRegistering 
                              ? 'Already have an account? '
                              : 'Didn\'t Register yet? ',
                          style: GoogleFonts.poppins(),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isRegistering = !_isRegistering;
                            });
                          },
                          child: Text(
                            _isRegistering ? 'Login here' : 'Click here',
                            style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}