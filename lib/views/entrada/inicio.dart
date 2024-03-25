import 'package:firebase/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cadastro.dart';
import 'login.dart';

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: um,
          textTheme: GoogleFonts.handleeTextTheme()),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Container(
                  margin: EdgeInsets.only(top: 160),
                  child: Text(
                    'Bem-Vindo \n ao\n Fashion!',
                    style: TextStyle(color: dois, fontSize: 60, height: 1.2),
                    textAlign: TextAlign.center,
                  )),
            ),
            SizedBox(
              height: 170,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: dois,
                    foregroundColor: tres,
                    minimumSize: Size(270, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
                )),
            SizedBox(height: 15),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: dois,
                    foregroundColor: tres,
                    minimumSize: Size(270, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Cadastro()));
                },
                child: Text(
                  'Cadastre-se',
                  style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
                ))
          ],
        ),
      ),
    );
  }
}
