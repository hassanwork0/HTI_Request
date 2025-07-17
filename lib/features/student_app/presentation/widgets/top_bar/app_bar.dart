
import 'package:flutter/material.dart';
import 'package:tables/core/localization/localization.dart';
import 'package:tables/features/student_app/data/models/student_model.dart';
import 'package:tables/features/student_app/presentation/widgets/top_bar/menu_btn.dart';

Widget buildTopMenu(Localization lang , BuildContext context , StudentModel student , bool logedIn) {
    
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(
            'https://i.imgur.com/Pr0QLYV.jpeg', // Replaced invalid URL with placeholder
            height: 40,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 40),
          ),
          if(logedIn)
          ...[
          Row(
            children: [
              buildMenuButton(lang.LANGUAGE, lang, context, logedIn,student),
              buildMenuButton(lang.PROFILE, lang, context, logedIn,student),
            ],
          ),
          ]
          else if(!logedIn)
          Row(
            children: [
              buildMenuButton(lang.LANGUAGE, lang, context, logedIn,student),
              buildMenuButton('Login', lang, context, logedIn,student),
            ],
          ),
          
        ],
      ),
    );
  }