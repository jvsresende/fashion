
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase/splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme:ThemeData(),
        home: Splash(),
      ));

  ThemeData(
      primarySwatch: dois,
      textTheme: GoogleFonts.handleeTextTheme(),
      scaffoldBackgroundColor: um,
      inputDecorationTheme: InputDecorationTheme(filled:true,
          fillColor: dois,
          contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: tres),
          ),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color:tres)),

          hintStyle: TextStyle(color: tres,))
  );


}
