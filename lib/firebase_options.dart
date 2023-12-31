// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDXtxii1yHmbUcDdFW5oAf-h2EkaEaT9CI',
    appId: '1:1077803017759:web:6cbd2f5876f9b15dadd72a',
    messagingSenderId: '1077803017759',
    projectId: 'flutter-deneme-takip',
    authDomain: 'flutter-deneme-takip.firebaseapp.com',
    storageBucket: 'flutter-deneme-takip.appspot.com',
    measurementId: 'G-CSMJ27NRFE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD1OxP09fiaHw8JhHor7OrTdbDt_s7V19w',
    appId: '1:1077803017759:android:ac41e1beab4f25aeadd72a',
    messagingSenderId: '1077803017759',
    projectId: 'flutter-deneme-takip',
    storageBucket: 'flutter-deneme-takip.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBxASYo7z3hzxEX9sxx8qrgIL6KhQJbs_M',
    appId: '1:1077803017759:ios:b782a46220aa5101add72a',
    messagingSenderId: '1077803017759',
    projectId: 'flutter-deneme-takip',
    storageBucket: 'flutter-deneme-takip.appspot.com',
    iosClientId:
        '1077803017759-fna2o4jlpshk9r9705iidf08dtmr0b2u.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterDenemeTakip',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBxASYo7z3hzxEX9sxx8qrgIL6KhQJbs_M',
    appId: '1:1077803017759:ios:74ec80ea83af0220add72a',
    messagingSenderId: '1077803017759',
    projectId: 'flutter-deneme-takip',
    storageBucket: 'flutter-deneme-takip.appspot.com',
    iosClientId:
        '1077803017759-bfo3tl1a1ngb4hpbq3671fnu8u8i5hmc.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterDenemeTakip.RunnerTests',
  );
}
