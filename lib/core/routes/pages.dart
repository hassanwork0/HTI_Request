import 'package:flutter/material.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/core/routes/names.dart';
import 'package:tables/features/morshed_app/data/models/morshed_model.dart';
import 'package:tables/features/morshed_app/presentation/screens/morshed_home.dart';
import 'package:tables/features/upload_app/upload.dart';
import 'package:tables/presentation/screens/login.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/screens/home.dart';
import 'package:tables/features/student_app/presentation/screens/profile.dart';
import 'package:tables/presentation/screens/splash.dart';
import '../error/error.dart';

class AppRoute {
  static const initial = RoutesName.initial;
  static bool isMorshedApp = false;

  static Route<dynamic> generate(RouteSettings settings) {
    // debugPrint('Route requested: ${settings.name} (MorshedApp: $isMorshedApp)');
    
    // Handle malformed route names
    if (settings.name == null || settings.name!.contains('=')) {
      debugPrint('Invalid route: ${settings.name}');
    }

      switch (settings.name) {
        case RoutesName.initial:

        case RoutesName.splash:
          return MaterialPageRoute(builder: (context) => const SplashScreen());
            
      case RoutesName.login:
        return MaterialPageRoute(
          builder: (context) =>LoginScreen()
        );

      case RoutesName.studentProfile:
        final args = settings.arguments as Map<String, dynamic>?;
        final student = args?['student'] as StudentModel;
        final myProfile = args?['myProfile'] as bool? ?? false;
        final lang = args?['lang'] as Localization;

        return MaterialPageRoute(
          builder: (context) => ProfileScreen(
            student: student,
            myProfile: myProfile,
            lang: lang,
          ),
        );

      case RoutesName.studentHome:
        final args = settings.arguments as Map<String, dynamic>?;
        final students = args?['students'] as List<StudentModel>? ?? [];
        final isLoggedIn = args?['isLoggedIn'] as bool? ?? false;
        final currentStudent = args?['currentStudent'] as StudentModel;

        return MaterialPageRoute(
          builder: (context) => HomeScreen(
            students: students,
            logedIn: isLoggedIn,
            student: currentStudent,
          ),
        );

      case RoutesName.morshedHome:
        final args = settings.arguments as Map<String, dynamic>?;
        final morshed = args?['currentMorshed'] as MorshedModel;
        final students = args?['students'] as List<StudentModel>;
        return MaterialPageRoute(
            builder: (context) => MorshedHomeScreen(
              currentMorshed: morshed,
              students: students
              ));

        case RoutesName.uploadStudent:
        return MaterialPageRoute(
          builder: (context) => UploadStudentsScreen()
        );

        case RoutesName.uploadMorshed:
        return MaterialPageRoute(
          builder: (context) => MorshedUploader()
        );

      // Unknown route
      default:
        throw RouteException('Route Exception');
    }
  }

}
