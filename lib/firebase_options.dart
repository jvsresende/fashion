// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
        
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
         
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
       
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
      
        );
      default:
        throw UnsupportedError(
          
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
  
  );

  static const FirebaseOptions android = FirebaseOptions(
   
  );
}
