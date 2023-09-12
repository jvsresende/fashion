import 'package:firebase/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../services/auth_service.dart';


class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecPass = TextEditingController();
  TextEditingController tecPass1 = TextEditingController();
  bool carregando = false;
  AuthService authService = AuthService();

  Future<void> salvarDados() async {
    try {
      if (tecPass.text == tecPass1.text) {
        await authService.registrar(context,tecEmail.text, tecPass.text);
      } else if(tecPass.text!=tecPass1.text){
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text('As Senhas se Diferem'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          tecPass.text = '';
                          tecPass1.text = '';
                        });
                        Navigator.of(context).pop(); // Fechar o AlertDialog
                      },
                      child:const Text('Ok',style: TextStyle(color:tres),),
                    )
                  ]
              );
            }
        );
      };
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text('Erro ao Realizar o Cadastro'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        tecPass.text = '';
                        tecPass1.text = '';
                        tecEmail.text = '';
                      });
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
        snackBarTheme: SnackBarThemeData(
          backgroundColor: dois, // Defina a cor de fundo desejada
          contentTextStyle: TextStyle(color: tres), // Defina o estilo do texto do SnackBar
        ),
      ),
      home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 190),
                    child: Text(
                      'Cadastro',
                      style: TextStyle(color: dois, fontSize: 60, height: 1.2),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 70),
                Email(tecEmail),
                SizedBox(height: 15),
                Pass(tecPass),
                SizedBox(height: 15),
                Pass1(tecPass1),
                SizedBox(height: 15),
                Text('A Senha deverá ter no Minimo 6 Caracteres',style: TextStyle(color:dois,fontSize: 15),),
                SizedBox(height:10),
                SizedBox(height: 70),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: tres,
                    minimumSize: Size(270, 50),
                    maximumSize: Size(270,50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: ()async{
    if (carregando) return;
    setState(() => carregando = true);
    try {
    await salvarDados();
    setState(() => carregando = false);
    } catch (e) {
    setState(() => carregando = false);
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Erro ao salvar os dados: $e')),
    );
    }
    },
      child: carregando ? Row(children: [
        CircularProgressIndicator(color:tres),
        Text('Cadastrando',style:TextStyle(fontSize:23,fontStyle:FontStyle.italic),)
      ],):Text('Cadastrar',style:TextStyle(fontSize:30,fontStyle:FontStyle.italic),),
                ),
              ],
            ),
          )

      ),
    );
  }}

class Email extends StatelessWidget {
  TextEditingController tecEmail;
  Email(this.tecEmail);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      child: TextField(
        controller: tecEmail,
        textAlignVertical: TextAlignVertical.center,
        autofocus: true,
        cursorColor: tres,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(color: tres),
        decoration: InputDecoration(
          hintMaxLines: 1,
          suffixIcon: Icon(
            PhosphorIcons.regular.envelope,
            size: 20.0,
            color: tres,
          ),
          hintText: 'digite o seu email',
        ),
      ),
    );
  }
}


class Pass extends StatelessWidget {
  TextEditingController tecPass;
  Pass(this.tecPass);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      child: TextField(
        controller: tecPass,
        textAlignVertical: TextAlignVertical.center,
        autofocus: true,
        cursorColor: tres,
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle(color: tres),
        decoration: InputDecoration(
          hintMaxLines: 1,
          suffixIcon: Icon(
            PhosphorIcons.regular.lock,
            size: 20.0,
            color: tres,
          ),
          hintText: 'digite a senha',
        ),
      ),
    );
  }
}

class Pass1 extends StatelessWidget {
  TextEditingController tecPass1;
  Pass1(this.tecPass1);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      child: TextField(
        controller: tecPass1,
        textAlignVertical: TextAlignVertical.center,
        autofocus: true,
        cursorColor: tres,
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle(color: tres),
        decoration: InputDecoration(
          hintMaxLines: 1,
          suffixIcon: Icon(
            PhosphorIcons.regular.lock,
            size: 20.0,
            color: tres,
          ),
          hintText: 'digite novamente a senha',
        ),
      ),
    );
  }
}
