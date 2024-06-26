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
    apiKey: 'AIzaSyC-cL-QZk723OKQSD-4qU-bsLD-SmbQL9Q',
    appId: '1:43132227235:android:658ce0fb558e93778db916',
    messagingSenderId: '43132227235',
    projectId: 'workgest-fb045',
    databaseURL: 'https://workgest-fb045-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'workgest-fb045.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCm-ppiYsys6SseIFzhVHS7vTBGEoEDnoQ',
    appId: '1:43132227235:ios:78274a83c5a9e3808db916',
    messagingSenderId: '43132227235',
    projectId: 'workgest-fb045',
    databaseURL: 'https://workgest-fb045-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'workgest-fb045.appspot.com',
    iosBundleId: 'com.abc.workgest.workgest',
  );
}
