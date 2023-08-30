/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'colors.dart';

class ListTextField extends StatefulWidget {
  @override
  _ListTextFieldState createState() => _ListTextFieldState();

}


class _ListTextFieldState extends State<ListTextField> {
  List<File> _imagens = [];
  bool selecionada = false;
  String? selecionado;
  List<String> itemList = []; // Lista de itens

  Future<void> escolher(ImageSource source) async {
    final escolher = ImagePicker();
    final imagemEscolhida = await escolher.pickImage(source: source);
    if (imagemEscolhida != null) {
      setState(() {
        _imagens.add(File(imagemEscolhida.path));
        selecionada = true;
      });
    }
    if(selecionada ==true){
      File cropped = (await ImageCropper().cropImage(
          sourcePath: _imagens.last.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 200,
          maxHeight: 200,
          uiSettings:[AndroidUiSettings(
              toolbarColor: tres,
              statusBarColor: tres.shade200,
              backgroundColor: dois)],
          compressFormat: ImageCompressFormat.jpg,

      )) as File;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List TextField'),
      ),
      body: Column(
        children: [
          GestureDetector(
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Selecione a Imagem'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            escolher(ImageSource.camera);
                          },
                          child:const Text('Câmera'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            escolher(ImageSource.gallery);
                          },
                          child: const Text('Galeria'),
                        ),
                      ],
                    );
                  }),
              child:Container(
                  margin: EdgeInsets.only(top: 50),
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    color: selecionada ? Colors.transparent : um,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: selecionada
                      ? Image.file(_imagens.last, fit:BoxFit.cover)
                      : Icon(
                      PhosphorIcons.regular.cameraPlus,
                      size: 60.0,
                      color:dois
                  )
              )
          ),
            ],
      ),
    );
  }
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase/views/entrada/inicio.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController tecNome = TextEditingController();
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecPass = TextEditingController();
  TextEditingController tecPass1 = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> salvarDados() async {
    try {
      if (tecPass.text == tecPass1.text) {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: tecEmail.text,
          password: tecPass.text,
        );

        if (userCredential.user != null) {
          Map<String, dynamic> dados = {
            'nome': tecNome.text,
            'email': tecEmail.text,
          };

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(dados);


        }

      }
      setState(() {
        tecPass.text='';
        tecPass1.text='';
      });
    } catch (e) {
      setState(() {
        tecPass.text='';
        tecPass1.text='';
        tecNome.text='';
        tecEmail.text='';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao realizar o cadastro: $e')),
      );
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(

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
                SizedBox(height: 60),
                Name(tecNome),
                SizedBox(height: 15),
                Email(tecEmail),
                SizedBox(height: 15),
                Pass(tecPass),
                SizedBox(height: 15),
                Pass1(tecPass1),
                SizedBox(height: 15),
                if (tecPass1.text != tecPass.text)
                  Text('As Senhas se diferem'),
                SizedBox(height: 60),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: tres,
                    minimumSize: Size(270, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: salvarDados,
                  child: Text(
                    'Cadastrar',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: tres,
                      fontSize: 26,
                    ),
                  ),
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
        obscureText: true, // Para esconder a senha
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


class Name extends StatelessWidget {
  TextEditingController tecNome;
  Name(this.tecNome);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      child: TextField(
        controller: tecNome,
        textAlignVertical: TextAlignVertical.center,
        autofocus: true,
        cursorColor: tres,
        keyboardType: TextInputType.text, // Use TextInputType.text para nome
        style: TextStyle(color: tres),
        decoration: InputDecoration(
          hintMaxLines: 1,
          suffixIcon: Icon(
            PhosphorIcons.regular.user,
            size: 20.0,
            color: tres,
          ),
          hintText: 'digite o nome',
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
        obscureText: true, // Para esconder a senha
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


