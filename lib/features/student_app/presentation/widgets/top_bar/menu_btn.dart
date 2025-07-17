
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/Bloc/home_bloc.dart';
import 'package:tables/features/student_app/presentation/Bloc/home_event.dart';
import 'package:tables/features/student_app/presentation/navigations/goto_login.dart';
import 'package:tables/features/student_app/presentation/navigations/goto_sp.dart';

Widget buildMenuButton(String text , Localization lang , BuildContext context , bool logedIn , StudentModel student) {
    return Container(
      margin: EdgeInsets.all(4),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: const Color(0xFF181D38),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          if(text == lang.LANGUAGE){
              context.read<HomeBloc>().add(ChangeLanguage(isArabic: !lang.lang));
          }else if(!logedIn) {
            gotoLogin(context);
          }else if(text == lang.PROFILE){
            gotoStudentProfile(context, student , true , lang);
          }
      
        },
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }