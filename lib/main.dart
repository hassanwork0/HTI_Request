import 'package:firebase_core/firebase_core.dart';
import 'package:tables/core/config/config.dart';
import 'package:tables/core/firebase/firebase_options.dart';
import 'package:flutter/material.dart';
import 'presentation/root_app.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load config from JSON
  final config = await _loadFirebaseConfig();
  
  // Set the configuration before initializing Firebase
  DefaultFirebaseOptions.setConfig(config);
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await DependencyInjection.init();
  runApp(const RootApp());
}

Future<Map<String, dynamic>> _loadFirebaseConfig() async {
  final contents = await rootBundle.loadString('assets/config.json');
  return jsonDecode(contents);
}