class RoutesName {
  // Initial route (authentication/splash screen)
  static const initial = '/';
  
  static const splash = '/splash';
  
  // Common routes (if any)
  static const login = '/login';
  static const password = '/password';
  
  // Student routes
  static const studentHome = '/student/home';
  static const studentProfile = '/student/profile';
  static const studentCourses = '/student/courses';
  static const studentGrades = '/student/grades';
  
  // Doctor routes
  static const morshedLogin = '/morshed/mlogin';
  static const morshedHome = '/morshed/home';
  static const morshedProfile = '/morshed/profile';
  static const morshedCourses = '/morshed/courses';
  static const morshedStudents = '/morshed/students';


  //Upload routes
  static const uploadStudent = 'uploadst';
  static const uploadMorshed = 'uploadmr';

  // Helper methods to determine user type
  static bool isStudentRoute(String route) {
    return route.startsWith('/student/');
  }

  static bool isMorshedRoute(String route) {
    return route.startsWith('/morshed/');
  }

  // You might also want a method to get the base path
  static String getBasePath(String route) {
    if (isStudentRoute(route)) return '/student';
    if (isMorshedRoute(route)) return '/morshed';
    return '';
  }
}