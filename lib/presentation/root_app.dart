import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tables/core/config/config.dart';
import 'package:tables/features/upload_app/upload.dart';
// import 'package:tables/core/firebase/upload.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/core/routes/names.dart';
import 'package:tables/core/routes/pages.dart';
import 'package:tables/features/student_app/presentation/Bloc/home_bloc.dart';

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    //The Launcher for the App
    return launcher();
  }

  launcher() {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => HomeBloc(
                initialStudents: [], // Provide initial students list
                initialLang: Localization(false), // Initial language
              ),
            ),
            // Add other BLoCs here as needed
          ],
          child: DismissKeyboard(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              // home: UploadStudentsScreen(),
              initialRoute: RoutesName.initial,
              onGenerateRoute: AppRoute.generate,
              // Remove BlocBuilder unless you specifically need to rebuild MaterialApp on state changes
            ),
          ),
        );
      },
    );
  }

  //  morshedApp() {
  //   return ScreenUtilInit(
  //     designSize: const Size(360, 690),
  //     minTextAdapt: true,
  //     splitScreenMode: true,
  //     builder: (context, child) {
  //       return MaterialApp(
  //         debugShowCheckedModeBanner: false,
  //         initialRoute: RoutesName.initial,
  //         onGenerateRoute: AppRoute.generate,
  //       );
  //     },
  //   );
  // }

  morshedUploadApp() {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MorshedUploader(),
        );
      },
    );
  }

  studentUploadApp() {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: RoutesName.uploadStudent,
          onGenerateRoute: AppRoute.generate,
        );
      },
    );
  }
}
