import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eye_dropper/eye_dropper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsluv/hsluvcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:firebase/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Adicionar extends StatelessWidget {
  const Adicionar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: tres,
          contentTextStyle: TextStyle(color: dois),
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
  String opc = "m";
  bool? tf;
  User? user = _auth.currentUser;
  bool carregando = false;
  String? hsluv;

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

      if (selecionado == 'j' ||
          selecionado == 'c' ||
          selecionado == 'bc' ||
          selecionado == 'bl' ||
          selecionado == 'r') {
        tf = true;
      } else if (selecionado == 'b' ||
          selecionado == 'ca' ||
          selecionado == 's' ||
          selecionado == 'sa') {
        tf = false;
      }

      // Converta a cor para HSLuv se a cor não for nula.
      String? corIdentificada;
      String? hsluv;
      if (cor != null) {
        final hsluvColor = HSLuvColor.fromColor(cor!);
        final hue = hsluvColor.hue;
        final saturation = hsluvColor.saturation;
        final lightness = hsluvColor.lightness;
        corIdentificada = identifyColor(hue, saturation, lightness);
      }
      if (cor != null) {
        hsluv = HSLuvColor.fromColor(cor!).toString();
      }

      Map<String, dynamic> dados = {
        'userId': userId,
        'imagem': urlImagem,
        'hsluv': hsluv, // Store HSLuv color data as a string
        'categoria': selecionado,
        'temperatura': opc,
        'corIdentificada': corIdentificada,
      };

      DocumentReference documentReference =
          await FirebaseFirestore.instance.collection('roupas').add(dados);

// Salvar o ID gerado automaticamente como um campo no documento
      await documentReference.update({'id': documentReference.id});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dados salvos com sucesso!')),
      );

      setState(() {
        _imagens.clear();
        cor = null;
        tf = null;
        selecionada = false;
        selecionado = null;
        opc = "m";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar os dados: $e')),
      );
    }
  }

  String identifyColor(double hue, double saturation, double lightness) {
    // Define hue ranges for each color category
    final colorRanges = [
      {'color': 'Amarelo Esverdeado', 'minHue': 45, 'maxHue': 90},
      {'color': 'Verde', 'minHue': 90, 'maxHue': 135},
      {'color': 'Verde Azulado', 'minHue': 135, 'maxHue': 180},
      {'color': 'Azul', 'minHue': 180, 'maxHue': 225},
      {'color': 'Azul Violeta', 'minHue': 225, 'maxHue': 270},
      {'color': 'Violeta', 'minHue': 270, 'maxHue': 315},
      {'color': 'Vermelho Violeta', 'minHue': 315, 'maxHue': 360},
      {'color': 'Vermelho', 'minHue': 0, 'maxHue': 45},
      {'color': 'Vermelho Alaranjado', 'minHue': 46, 'maxHue': 60},
      {'color': 'Laranja', 'minHue': 61, 'maxHue': 120},
      {'color': 'Laranja Amarelado', 'minHue': 121, 'maxHue': 180},
      {'color': 'Amarelo', 'minHue': 181, 'maxHue': 210},
    ];

    // Loop through color ranges to identify the color
    for (final range in colorRanges) {
      final minHue = range['minHue'] as int;
      final maxHue = range['maxHue'] as int;
      final colorName = range['color'] as String;

      if (hue >= minHue && hue <= maxHue) {
        return colorName;
      }
    }

    // If the hue doesn't match any specific range, return "Outra"
    return 'Outra';
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
  }

  @override
  void initState() {
    super.initState();
    User? user = _auth.currentUser;
    if (user != null) {
      userId = user.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Selecione a Imagem'),
                        content: const Text(
                            "Imagem de prefêrencia seja quadrada (1:1)"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              escolher(ImageSource.camera);
                            },
                            child: const Text('Câmera'),
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
                    },
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      color: selecionada ? Colors.transparent : um,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: selecionada
                            ? Image.file(_imagens.last, fit: BoxFit.cover)
                            : Icon(
                                PhosphorIcons.regular.cameraPlus,
                                size: 60.0,
                                color: dois,
                              )),
                  ),
                ),
                SizedBox(height: 40),
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
                    height: 50,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: um),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Selecione a Cor',
                            style: TextStyle(color: tres, fontSize: 18)),
                        SizedBox(width: 10),
                        Icon(
                          PhosphorIcons.regular.eyedropper,
                          color: tres,
                          size: 22.0,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: 350,
                  height: 50,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: um,
                  ),
                  child: DropdownButton(
                    underline: Container(),
                    style: TextStyle(color: dois, fontSize: 16),
                    items: const [
                      DropdownMenuItem(child: Text("Categoria"), value: ""),
                      DropdownMenuItem(
                          child: Text('Blusa Manga Curta'), value: 'bc'),
                      DropdownMenuItem(
                          child: Text('Blusa Manga Longa'), value: 'bl'),
                      DropdownMenuItem(child: Text('Regata'), value: 'r'),
                      DropdownMenuItem(child: Text('Jaqueta'), value: 'j'),
                      DropdownMenuItem(child: Text('Casacos'), value: 'c'),
                      DropdownMenuItem(child: Text('Bermuda'), value: 'b'),
                      DropdownMenuItem(child: Text('Calça'), value: 'ca'),
                      DropdownMenuItem(child: Text('Short'), value: 's'),
                      DropdownMenuItem(child: Text('Vestido'), value: 'v'),
                      DropdownMenuItem(child: Text('Saia'), value: 'sa'),
                    ],
                    isExpanded: true,
                    value: selecionado,
                    onChanged: (value) {
                      setState(() {
                        selecionado = value;
                      });
                    },
                    icon: Icon(
                      PhosphorIcons.bold.caretDown,
                      size: 20.0,
                      color: dois,
                    ),
                    dropdownColor: um,
                    hint: Text('Categoria', style: TextStyle(color: dois)),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  "Estação/Temperatura:",
                  style: TextStyle(fontSize: 28, color: tres),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: Row(
                          children: <Widget>[
                            Radio(
                              value: "f",
                              groupValue: opc,
                              onChanged: (value) {
                                setState(() {
                                  opc = value.toString();
                                });
                              },
                            ),
                            const Text('Fria', style: TextStyle(color: tres)),
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
                              onChanged: (value) {
                                setState(() {
                                  opc = value.toString();
                                });
                              },
                            ),
                            Text('Média', style: TextStyle(color: tres)),
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
                              onChanged: (value) {
                                setState(() {
                                  opc = value.toString();
                                });
                              },
                            ),
                            Text('Quente', style: TextStyle(color: tres)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: dois,
                          foregroundColor: tres,
                          minimumSize: Size(100, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        setState(() {
                          _imagens.clear();
                          cor = null;
                          tf = null;
                          selecionada = false;
                          selecionado = null;
                          opc = "m";
                        });
                      },
                      child: Text('Cancelar',
                          style: TextStyle(
                              fontSize: 30, fontStyle: FontStyle.italic)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: tres,
                          foregroundColor: dois,
                          minimumSize: Size(200, 50),
                          maximumSize: Size(200, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () async {
                        if (carregando) return;
                        setState(() => carregando = true);
                        try {
                          await salvarDados();
                          setState(() => carregando = false);
                        } catch (e) {
                          setState(() => carregando = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Erro ao salvar os dados: $e')),
                          );
                        }
                      },
                      child: carregando
                          ? Row(children: [
                              CircularProgressIndicator(color: um),
                              Text('  Enviando',
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontStyle: FontStyle.italic)),
                            ])
                          : Text('Enviar',
                              style: TextStyle(
                                  fontSize: 30, fontStyle: FontStyle.italic)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
