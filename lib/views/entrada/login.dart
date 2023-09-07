import 'package:firebase/colors.dart';
import 'package:firebase/views/entrada/redefinicao.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../services/auth_service.dart';
import '../roupas/menu.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecPass = TextEditingController();
  AuthService authService = AuthService();
  bool carregando = false;
  Future<void> fazerLogin() async {
    try {
      await authService.login(context,tecEmail.text, tecPass.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Navegar(0)));

    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text('Erro ao Realizar o Login'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:const Text('Okay',style: TextStyle(color:tres),),
                  )
                ]
            );
          }
      );
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
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
        body: SingleChildScrollView(child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Center(
            child:Container(
                margin: EdgeInsets.only(top: 190),
                child: Text('Login',
                  style: TextStyle(color: dois, fontSize: 60,height: 1.2),
                  textAlign: TextAlign.center,
                )),
          ),
            SizedBox(height: 150,),
            Email(tecEmail),
            SizedBox(height:15),
            Pass(tecPass),
            GestureDetector(
             onTap:(){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Redefinir()));},
              child:
              Align(
                alignment: Alignment(0.8,0),child: Text('Esqueceu a senha',
                  style:TextStyle(color:dois, decoration: TextDecoration.underline,fontSize:18),
               ),
             ),
            ),
            SizedBox(height:30),
            ElevatedButton(
                style: ElevatedButton.styleFrom(foregroundColor: tres,minimumSize: Size(270,50),
                    maximumSize:Size(270,50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: ()async{
                if (carregando) return;
                setState(() => carregando = true);
                try {
                  await fazerLogin();
                  setState(() => carregando = false);
                } catch (e) {
                  setState(() => carregando = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao carregar os dados: $e')),
                  );
                }
              },
              child: carregando ? Row(children: [
                CircularProgressIndicator(color:dois),
                Text('Carregando',style:TextStyle(fontSize:23,fontStyle:FontStyle.italic),)
              ],):Text('Login',style:TextStyle(fontSize:30,fontStyle:FontStyle.italic),),
            )
          ],
        ),)

      ),
    );
  }}

class Email extends StatelessWidget {
  TextEditingController tecEmail;
  Email(this.tecEmail);
  @override
  Widget build(BuildContext context) {
    return
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
      );
  }
}

class Pass extends StatelessWidget {
  TextEditingController tecPass;
  Pass(this.tecPass);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: 350,
        child:   TextField(
          controller: tecPass,
            textAlignVertical: TextAlignVertical.center,
            autofocus: true,
            cursorColor: tres,
            obscureText: true,
            style: TextStyle(color:tres),
            decoration:
            InputDecoration(
              hintMaxLines: 1,
                suffixIcon:Icon(
                  PhosphorIcons.regular.lock,
                  size: 20.0,
                  color: tres,
                ),
                hintText:'senha',
            )
        ),
      );
  }
}
