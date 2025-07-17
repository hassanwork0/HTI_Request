import 'package:flutter/material.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/core/routes/names.dart';
import 'package:tables/features/morshed_app/data/models/morshed_model.dart';
import 'package:tables/features/morshed_app/presentation/screens/morshed_home.dart';
import 'package:tables/presentation/screens/morshed/morshed_login.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/screens/home.dart';
import 'package:tables/features/student_app/presentation/screens/profile.dart';
import 'package:tables/presentation/screens/student/student_login.dart';
import 'package:tables/presentation/screens/splash.dart';

class RouteException implements Exception {
  final String message;
  const RouteException(this.message);
}

class AppRoute {
  static const initial = RoutesName.initial;

  static Route<dynamic> generate(RouteSettings? settings) {
    final routeName = settings?.name ?? RoutesName.initial;
    // print('Generating route: $routeName'); // Debug log

    switch (routeName) {
      case RoutesName.initial:
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(
          ),
          settings: settings,
        );

      case RoutesName.login:
        return MaterialPageRoute(
          builder: (context) => const StudentLoginScreen(),
          settings: settings,
        );

      case RoutesName.studentProfile:
        final args = settings?.arguments as Map<String, dynamic>?;
        if (args == null || args['student'] == null || args['lang'] == null) {
          return _errorRoute('Missing arguments for student profile');
        }
        return MaterialPageRoute(
          builder: (context) => ProfileScreen(
            student: args['student'] as StudentModel,
            myProfile: args['myProfile'] as bool? ?? false,
            lang: args['lang'] as Localization,
          ),
          settings: settings,
        );

      case RoutesName.studentHome:
        final args = settings?.arguments as Map<String, dynamic>?;
        if (args == null || args['currentStudent'] == null) {
          return _errorRoute('Missing arguments for student home');
        }
        return MaterialPageRoute(
          builder: (context) => HomeScreen(
            students: args['students'] as List<StudentModel>? ?? [],
            logedIn: args['isLoggedIn'] as bool? ?? false,
            student: args['currentStudent'] as StudentModel,
          ),
          settings: settings,
        );

      case RoutesName.morshedLogin:
        return MaterialPageRoute(
          builder: (context) => const MorshedLoginScreen(),
          settings: settings,
        );

      case RoutesName.morshedHome:
        final args = settings?.arguments as Map<String, dynamic>?;
        if (args == null || args['currentMorshed'] == null) {
          return _errorRoute('Missing morshed data for home screen');
        }
        return MaterialPageRoute(
          builder: (context) => MorshedHomeScreen(
            currentMorshed: args['currentMorshed'] as MorshedModel,
            students: args['students'] as List<StudentModel>,
            
          ),
          settings: settings,
        );

      default:
        return _errorRoute('Route not found: $routeName');
    }
  }

  static MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
