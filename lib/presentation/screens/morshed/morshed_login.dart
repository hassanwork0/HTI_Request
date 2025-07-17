import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tables/core/routes/names.dart';
import 'package:tables/features/morshed_app/data/models/morshed_model.dart';
import 'package:tables/features/morshed_app/data/sources/morshed_remote_data.dart';
import 'package:tables/features/student_app/data/implements/student_impt.dart';
import 'package:tables/presentation/widgets/switcher.dart';

class MorshedLoginScreen extends StatefulWidget {
  const MorshedLoginScreen({super.key});

  @override
  State<MorshedLoginScreen> createState() => _MorshedLoginScreenState();
}

class _MorshedLoginScreenState extends State<MorshedLoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;
  final MorshedRemoteData _morshedRepository = MorshedRemoteData();

  @override
  void initState() {
    super.initState();
    _checkRememberedUser();
  }

  Future<void> _checkRememberedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberedMorshedJson = prefs.getString('currentMorshed');

    if (rememberedMorshedJson != null) {
      final morshedMap = jsonDecode(rememberedMorshedJson) as Map<String, dynamic>;
      setState(() {
        _idController.text = morshedMap['login_name']?.toString() ?? '';
        _passwordController.text = prefs.getString('rememberedMorshedPassword') ?? '';
        _rememberMe = true;
      });
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

  Future<void> _saveRememberedUser(MorshedModel morshed, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      // print(morshed.toJson());
      await prefs.setString('currentMorshed', jsonEncode(morshed.toJson()));
      await prefs.setString('rememberedMorshedPassword', password);
    } else {
      await prefs.remove('currentMorshed');
      await prefs.remove('rememberedMorshedPassword');
    }
  }

  Future<void> _handleLogin() async {
    final name = _idController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty) {
      _showSnackbar('Please enter your ID!');
      return;
    }

    if (password.isEmpty) {
      _showSnackbar('Please enter your password!');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final morshed = await _morshedRepository.getMorshed(name, password);

      // Save to SharedPreferences if remember me is checked
      await _saveRememberedUser(morshed, password);

      // Navigation
      if (context.mounted) {
    final StudentImpt str = StudentImpt();
    final studentsFuture = str.getAllStudents();

    // Wait for students and delay concurrently
    final students = await studentsFuture;
    
        Navigator.pushReplacementNamed(
          context,
          RoutesName.morshedHome,
          arguments: {
            'currentMorshed': morshed,
            'students':students
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
                        // Handle link tap (e.g., open URL)
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
                      keyboardType: TextInputType.text, // Changed to text as morshedId may not be numeric
                      decoration: InputDecoration(
                        labelText: 'Morshed Name',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
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
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'LOGIN',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
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