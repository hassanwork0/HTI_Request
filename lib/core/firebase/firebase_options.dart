import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static Map<String, dynamic>? _config;

  static void setConfig(Map<String, dynamic> config) {
    _config = config;
  }

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions get web {
    if (_config == null) throw Exception('Firebase config not initialized');
    return FirebaseOptions(
      apiKey: _config!['firebase']['web']['apiKey'],
      appId: _config!['firebase']['web']['appId'],
      messagingSenderId: _config!['firebase']['web']['messagingSenderId'],
      projectId: _config!['firebase']['web']['projectId'],
      authDomain: _config!['firebase']['web']['authDomain'],
      storageBucket: _config!['firebase']['web']['storageBucket'],
      measurementId: _config!['firebase']['web']['measurementId'],
    );
  }

  static FirebaseOptions get android {
    if (_config == null) throw Exception('Firebase config not initialized');
    return FirebaseOptions(
      apiKey: _config!['firebase']['android']['apiKey'],
      appId: _config!['firebase']['android']['appId'],
      messagingSenderId: _config!['firebase']['android']['messagingSenderId'],
      projectId: _config!['firebase']['android']['projectId'],
      storageBucket: _config!['firebase']['android']['storageBucket'],
    );
  }

  // Add other platform getters as needed (ios, macos, windows)
}