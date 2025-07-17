import 'package:flutter/material.dart';
import 'package:tables/core/routes/names.dart';
import 'package:tables/core/routes/pages.dart';
import 'package:tables/data/departments/electrical.dart';
import 'package:tables/features/morshed_app/data/models/morshed_model.dart';
import 'package:tables/features/morshed_app/domain/entities/morshed_dr.dart';
import 'package:tables/features/morshed_app/domain/entities/morshed_eng.dart';
import 'package:tables/features/student_app/data/implements/student_impt.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/navigations/goto_home.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _navigateAfterDelay(BuildContext context) async {
    final delayFuture = Future.delayed(const Duration(seconds: 3));

    if (!context.mounted) return;
    if (AppRoute.isMorshedApp) {
      await delayFuture;
      Navigator.pushReplacementNamed(context, RoutesName.login);
      return;
    }
    final StudentImpt str = StudentImpt();
    final studentsFuture = str.getAllStudents();

    // Wait for students and delay concurrently
    final students = await studentsFuture;

    await delayFuture;

    try {
      final currentStudent = await str.verifyRememberedUser();
      if (currentStudent != null) {
        // Navigate as logged-in user
        gotoHome(
          context,
          students,
          await str.getStudentById(id :currentStudent.id), // Refresh student data
          true,
        );
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error verifying remembered user: $e'),
        ),
      );
    }

    // Navigate as guest if no valid remembered user
    StudentModel guest = StudentModel(
      id: -1,
      name: "Guest",
      gpa: 0,
      units: 0,
      department: Electrical(),
      morshedDr: MorshedModel.fromDr(MorshedDr(id: '-1', name: 'not found',department: Electrical())),
      morshedEng: MorshedModel.fromEng(MorshedEng(doctorId:'-1' , id: '-2', name: 'not found',department: Electrical())),
    );
    gotoHome(context, students, guest, false);
  }

  @override
  Widget build(BuildContext context) {
    _navigateAfterDelay(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.network(
          'https://i.imgur.com/Pr0QLYV.jpeg',
          height: 200,
          width: 200,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.error,
            size: 100,
            color: Colors.red,
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
