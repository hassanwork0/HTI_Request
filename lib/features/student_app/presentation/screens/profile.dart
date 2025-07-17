import 'package:flutter/material.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/widgets/profile/profileBuilders/profile_menu.dart';
import 'package:tables/features/student_app/presentation/widgets/profile/profileBuilders/student_details.dart';

class ProfileScreen extends StatelessWidget {
  final StudentModel student;
  final bool myProfile; // New parameter
  final Localization lang;
  const ProfileScreen({super.key, required this.student, this.myProfile = false , required this.lang});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cover Photo Section with Back Button and Menu
            profileMenu(context,student,myProfile),

            // Profile Picture and Info Section
            studentDetails(student, myProfile, lang, context),
          ],
        ),
      ),
    );
  }

 
}