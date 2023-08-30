import 'package:firebase/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';


class Redefinir extends StatefulWidget {
  @override
  _RedefinirState createState() => _RedefinirState();
}

class _RedefinirState extends State<Redefinir> {
  TextEditingController tecEmail = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> redefinir(String email) async {
    try {
      var user = await _auth.fetchSignInMethodsForEmail(email);
      if (user != null && user.isNotEmpty) {
        await redefinir(email);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Usuário não encontrado'),
              content: Text('O email informado não está cadastrado.'),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        tecEmail.text = '';
                      });
                      Navigator.of(context).pop(); // Fechar o AlertDialog
                    },
                  child: Text('Okay',style: TextStyle(color:tres),)
                ),
              ],
            );
          },
        );
      }
    } catch (e) {

    }
  }

  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: um,
        primarySwatch: dois,
        textTheme: GoogleFonts.handleeTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
            filled:true,
            fillColor: dois,

            contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: tres),
            ),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color:tres)),

            hintStyle: TextStyle(color: tres,)
        ),
      ),
      home: Scaffold(
        body: SingleChildScrollView(child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Center(
            child:Container(
                margin: EdgeInsets.only(top: 160),
                child: Text('Redefinir \n Senha:',
                  style: TextStyle(color: dois, fontSize: 60,height: 1.2),
                  textAlign: TextAlign.center,
                )),

          ),
            SizedBox(height: 125,),
            Container(
              width: 350,
              child:   TextField(
                  controller: tecEmail,
                  textAlignVertical: TextAlignVertical.center,
                  autofocus: true,
                  cursorColor: tres,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color:tres),
                  decoration:
                  InputDecoration(
                    hintMaxLines: 1,
                    suffixIcon:Icon(
                      PhosphorIcons.regular.user,
                      size: 20.0,
                      color: tres,
                    ),
                    hintText:'email',
                  )
              ),
            ),
            SizedBox(height:90),
            ElevatedButton(
                style: ElevatedButton.styleFrom(foregroundColor: tres,minimumSize: Size(270,50),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed:(){redefinir(tecEmail.text);},
                child: Text('Enviar Email', style: TextStyle(fontStyle: FontStyle.italic,color: tres,fontSize: 26),))
          ],
        ),),
        ),
    );

  }}