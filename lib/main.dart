import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firestore.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: dois,
      primarySwatch: tres,
      textTheme: GoogleFonts.handleeTextTheme(),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dois,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: um),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: um),
        ),
        hintStyle: TextStyle(
          color: um,
        ),
      ),
      unselectedWidgetColor: um,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: tres,
        contentTextStyle: TextStyle(color: dois),
      ),
    ),
    home: Splash(),
  ));
}
