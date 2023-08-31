import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eye_dropper/eye_dropper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:firebase/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Adicionar extends  StatelessWidget {
  const Adicionar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)  {
    return MaterialApp(
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
          backgroundColor: tres, // Defina a cor de fundo desejada
          contentTextStyle: TextStyle(color: dois), // Defina o estilo do texto do SnackBar
        ),
      ),
      home: const Ad(title: 'Adicionar'),
      builder: (context, child) => EyeDropper(
        child: child!,
      ),
    );
  }
}

class Ad extends StatefulWidget {
  const Ad({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Ad> createState() => _AdState();
}
FirebaseAuth _auth = FirebaseAuth.instance;
class _AdState extends State<Ad> {

  Color? cor;
  List<File> _imagens = [];
  bool selecionada = false;
  String? selecionado;
  String? selecionad;
  String? opc;
  bool? tf;
  User? user = _auth.currentUser;

  String userId = '';
  Future<String> enviarImagem(File imagem) async {
    try {
      String userId = _auth.currentUser?.uid ?? '';
      
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('roupas/${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(imagem);

      
      String url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Erro ao enviar imagem para o Storage: $e');
      return '';
    }
  }


  Future<void> salvarDados() async {
    try {
      String urlImagem = await enviarImagem(_imagens.last);

      if(selecionado == 'j' || selecionado == 'c' || selecionado == 'bc' || selecionado == 'bl' || selecionado == 'r') {
        tf = true;
      }else if(selecionado == 'b' || selecionado == 'ca' || selecionado == 's' || selecionado == 'sa'){
        tf=false;
      }
      String? hex =cor != null ? '#${cor!.value.toRadixString(16).substring(2).toUpperCase()}' : '';

      // Crie um mapa com as informações que deseja salvar
      Map<String, dynamic> dados = {
        'userId':userId,
        'imagem': urlImagem, // Substitua 'URL_da_imagem' pela URL da imagem, caso você a esteja salvando no Firebase Storage, por exemplo.
        'cor': hex, // Salve a cor como um valor numérico, ou qualquer outro formato desejado.
        'categoria': tf,
        'ocasiao': selecionad,
        'temperatura': opc,
         };

      await FirebaseFirestore.instance.collection('roupas').add(dados);

      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dados salvos com sucesso!')),
      );

      
      setState(() {
        _imagens.clear();
        hex = null;
        cor =null;
        tf = null;
        selecionada = false;
        selecionado = null;
        selecionad = null;
        opc = null;
      });

    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar os dados: $e')),
      );
    }
  }


  Future<void> escolher(ImageSource source) async {
    final escolher = ImagePicker();
    final imagemEscolhida = await escolher.pickImage(source: source);
    if (imagemEscolhida != null) {
      setState(() {
        _imagens.add(File(imagemEscolhida.path));
        selecionada = true;
      });
    }
   /* if(selecionada ==true){
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
   _imagens.last=cropped;
    }*/
  }

  @override
  void initState() {
    super.initState();
    User? user = _auth.currentUser;
    if (user != null) {
      userId = user.uid; // Atribua o ID do usuário à variável userId
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: Center(
          child: SingleChildScrollView(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        child: ClipRRect( // ClipRRect para garantir que a imagem também tenha bordas arredondadas
                            borderRadius: BorderRadius.circular(10.0),
                            child: selecionada
                                ? Image.file(_imagens.last, fit:BoxFit.cover)
                                : Icon(
                                PhosphorIcons.regular.cameraPlus,
                                size: 60.0,
                                color:dois
                        )
                    )
                ),
                ),
                SizedBox(height:25),
                    GestureDetector(
                    onTap: () {
                      EyeDropper.enableEyeDropper(context, (color) {
                        setState(() {
                          cor = color;
                        });
                      });
                    },
                    child: Container(
                        width: 350,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: um),
                        ),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Selecione a Cor',style: TextStyle(color:um,fontSize: 18),),
                          SizedBox(width:10),
                          Icon(
                            PhosphorIcons.regular.eyedropper,
                            color: um,
                            size: 22.0,
                          ),
                        ],)

                    ),
                  ),
                SizedBox(height:25),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:[
                    Container(
                      width: 150,
                      height:45,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: um,
                      ),
                      child:DropdownButton(
                        underline: Container(
                        ),
                        style: TextStyle(color: dois,fontSize:16),
                        items: const [
                          DropdownMenuItem(child: Text("Categoria"), value: ""),
                          DropdownMenuItem(child: Text('Blusa Manga Curta'),value:'bc'),
                          DropdownMenuItem(child: Text('Blusa Manga Longa'),value:'bl'),
                          DropdownMenuItem(child: Text('Regata'),value:'r'),
                          DropdownMenuItem(child: Text('Jaqueta',),value:'j'),
                          DropdownMenuItem(child: Text('Casacos'),value:'c'),
                          DropdownMenuItem(child: Text('Bermuda'),value:'b'),
                          DropdownMenuItem(child: Text('Calça'),value:'ca'),
                          DropdownMenuItem(child: Text('Short'),value:'s'),
                          DropdownMenuItem(child: Text('Vestido'),value:'v'),
                          DropdownMenuItem(child: Text('Saia'),value:'sa'),
                        ],
                        isExpanded:true,
                        value: selecionado,
                        onChanged: (value) {
                          setState(() {
                            selecionado = value;
                          });
                        },
                        icon: Icon(
                            PhosphorIcons.bold.caretDown,
                            size: 20.0,
                            color:dois
                        ),
                        dropdownColor: um,
                        hint: Text('Categoria',style:TextStyle(color:dois)),
                      ),
                    ),
                  Container(
                    width: 150,
                    height:45,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: um,
                    ),
                    child:DropdownButton(
                      underline: Container(
                      ),
                      style: TextStyle(color: dois,fontSize:16),
                      items: const [
                        DropdownMenuItem(child: Text("Ocasião"), value: " "),
                        DropdownMenuItem(child: Text('Simples',),value:'simples'),
                        DropdownMenuItem(child: Text('Especial',),value:'especial'),
                        DropdownMenuItem(child: Text('Festa',),value:'festa'),
                        DropdownMenuItem(child: Text('Saída'),value:'saida')
                      ],
                      isExpanded:true,
                      value: selecionad,
                      onChanged: (value) {
                        setState(() {
                          selecionad = value;
                        });
                      },
                      icon: Icon(
                          PhosphorIcons.bold.caretDown,
                          size: 20.0,
                          color:dois
                      ),
                      dropdownColor: um,
                      hint: Text('Ocasião',style:TextStyle(color:dois)),
                    ),
                  ),
                  ]
                ),
                Divider(color:dois),
                Text("Temperatura:", style: TextStyle(fontSize: 28,color: um),),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: Row(
                          children: <Widget>[
                            Radio(
                              value: "f",
                              groupValue: opc,
                              onChanged: (value){
                                setState(() {
                                  opc = value.toString();
                                });
                              },
                            ),
                            const Text('Frio', style: TextStyle(color:um)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Row(
                          children: <Widget>[
                            Radio(
                              value: "m",
                              groupValue: opc,
                              onChanged: (value){
                                setState(() {
                                  opc = value.toString();
                                });
                              },
                            ),
                            Text('Médio', style: TextStyle(color:um)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Row(
                          children: <Widget>[
                            Radio(
                              value: "q",
                              groupValue: opc,
                              onChanged: (value){
                                setState(() {
                                  opc = value.toString();
                                });
                              },
                            ),
                            Text('Quente', style: TextStyle(color:um)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height:25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: dois,
                            foregroundColor: tres,
                            minimumSize: Size(100,50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: (){},
                        child: Text('Cancelar',style: TextStyle(fontSize:30,fontStyle:FontStyle.italic),)),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: tres,
                            foregroundColor: dois,
                            minimumSize: Size(200,50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: salvarDados,
                        child: Text('Salvar',style:  TextStyle(fontSize:30,fontStyle:FontStyle.italic),)
                    )
                  ],
                )
              ],
            ),
          ),
        )
        )
    );
  }
}
