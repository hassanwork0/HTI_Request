import 'package:flutter/material.dart';
import 'package:tables/core/routes/names.dart';
import 'package:tables/core/routes/pages.dart';

switcher(BuildContext context){
  return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'switch') {
                AppRoute.isMorshedApp = !AppRoute.isMorshedApp;
                Navigator.pushReplacementNamed(context, RoutesName.login);
              }
            },
            itemBuilder: (BuildContext context) => [
               PopupMenuItem<String>(
                value: 'switch',
                child: Text('Switch to ${ AppRoute.isMorshedApp ? 'Student':'Morshed'} App'),
              ),
            ],
          ),
        ],
      );
}