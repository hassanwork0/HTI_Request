import 'package:flutter/material.dart';
import 'package:tables/core/routes/pages.dart';
import 'package:tables/presentation/screens/morshed/morshed_login.dart';
import 'package:tables/presentation/screens/student/student_login.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    if(AppRoute.isMorshedApp){
    return MorshedLoginScreen();
    }else{
      return StudentLoginScreen();
    }
  }
}