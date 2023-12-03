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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAbItQoakO0cA3l4-4YYIczXaiwYfLSzxc',
    appId: '1:104119207444:android:42a8de45c072f0cafa0901',
    messagingSenderId: '104119207444',
    projectId: 'induk-community',
    storageBucket: 'induk-community.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNQtBGNUt6-iq41EIX5UH5pYUKP3-BnSU',
    appId: '1:104119207444:ios:91e5c5dbc9071223fa0901',
    messagingSenderId: '104119207444',
    projectId: 'induk-community',
    storageBucket: 'induk-community.appspot.com',
    androidClientId: '104119207444-bqpdhr5qkm1gcdopjv28hha0jrc1o1s0.apps.googleusercontent.com',
    iosClientId: '104119207444-bjm3g1cgq4bslnqnvathicb0hsvmr19h.apps.googleusercontent.com',
    iosBundleId: 'com.algoitzm.indukjt',
  );
}