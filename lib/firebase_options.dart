// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyADqL7J6rFnCV11WSMy10MRKgd2vX-yizA',
    appId: '1:869155390774:web:4ac4cd7c87e398060c5f97',
    messagingSenderId: '869155390774',
    projectId: 'chatappp-7fb42',
    authDomain: 'chatappp-7fb42.firebaseapp.com',
    storageBucket: 'chatappp-7fb42.appspot.com',
    measurementId: 'G-7W3ZHD229J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCAeNxedeybjP2N1ItT5F_U9LDVuwhOlSU',
    appId: '1:869155390774:android:f83362b81a55ad990c5f97',
    messagingSenderId: '869155390774',
    projectId: 'chatappp-7fb42',
    storageBucket: 'chatappp-7fb42.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAfzD1tigf-dtsP9YFuQhD8PejcyEscrkA',
    appId: '1:869155390774:ios:328e227443b555fb0c5f97',
    messagingSenderId: '869155390774',
    projectId: 'chatappp-7fb42',
    storageBucket: 'chatappp-7fb42.appspot.com',
    iosBundleId: 'com.example.instagrem',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAfzD1tigf-dtsP9YFuQhD8PejcyEscrkA',
    appId: '1:869155390774:ios:328e227443b555fb0c5f97',
    messagingSenderId: '869155390774',
    projectId: 'chatappp-7fb42',
    storageBucket: 'chatappp-7fb42.appspot.com',
    iosBundleId: 'com.example.instagrem',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyADqL7J6rFnCV11WSMy10MRKgd2vX-yizA',
    appId: '1:869155390774:web:3b6227d88235256d0c5f97',
    messagingSenderId: '869155390774',
    projectId: 'chatappp-7fb42',
    authDomain: 'chatappp-7fb42.firebaseapp.com',
    storageBucket: 'chatappp-7fb42.appspot.com',
    measurementId: 'G-V21TXRM95D',
  );

}