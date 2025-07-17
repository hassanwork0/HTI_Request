import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tables/core/routes/names.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';

Stack profileMenu(BuildContext context , StudentModel student,bool myProfile){
  return Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[500],
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                if (myProfile) // Show menu only if myProfile is true
                  Positioned(
                    top: 40,
                    right: 16,
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) {
                        if (value == 'change_password') {
                          _showChangePasswordDialog(context , student);
                        } else if (value == 'log_out') {
                          _handleLogout(context);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'change_password',
                          child: Row(
                            children: [
                              Icon(Icons.lock, color: Colors.black),
                              SizedBox(width: 8),
                              Text('Change Password'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'log_out',
                          child: Row(
                            children: [
                              Icon(Icons.logout, color: Colors.black),
                              SizedBox(width: 8),
                              Text('Log Out'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
}

 void _showChangePasswordDialog(BuildContext context , StudentModel student) {
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final newPassword = newPasswordController.text.trim();
              final confirmPassword = confirmPasswordController.text.trim();

              if (newPassword.isEmpty || confirmPassword.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in both fields')),
                );
                return;
              }

              if (newPassword != confirmPassword) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
                return;
              }

              try {
                await FirebaseFirestore.instance
                    .collection('students')
                    .doc(student.id.toString())
                    .update({'password': newPassword});

                // Update SharedPreferences if the user is remembered
                final prefs = await SharedPreferences.getInstance();
                if (prefs.containsKey('currentStudent')) {
                  await prefs.setString('rememberedStudentPassword', newPassword);
                }

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password updated successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating password: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    // Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentStudent');
    await prefs.remove('rememberedStudentPassword');

    // Navigate to LoginScreen
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.login, // Assuming you have a login route defined
        (route) => false, // Remove all previous routes
      );
    }
  }