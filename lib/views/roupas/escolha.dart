import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'dart:math';

import '../../colors.dart';

class Escolher extends StatefulWidget {
  @override
  _EscolherState createState() => _EscolherState();
}

class _EscolherState extends State<Escolher> {
  List<Map<String, dynamic>> _cima = [];
  List<Map<String, dynamic>> _baixo = [];
  Map<String, dynamic>? _cimas;
  Map<String, dynamic>? _baixos;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> carregar() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        QuerySnapshot queryCima = await FirebaseFirestore.instance.collection('roupas')
            .where('userId', isEqualTo: userId)
            .where('categoria', isEqualTo: true)
            .get();

        _cima = queryCima.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        QuerySnapshot queryBaixo = await FirebaseFirestore.instance.collection('roupas')
            .where('userId', isEqualTo: userId)
            .where('categoria', isEqualTo: false)
            .get();

        _baixo = queryBaixo.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        // Chame aleatorio() para carregar as primeiras roupas
        aleatorio();
      }
    } catch (e) {
      print('Erro ao carregar as roupas: $e');
    }
  }

  void aleatorio() {
    Random alea = Random();
    if (_cima.isNotEmpty) {
      int iC = alea.nextInt(_cima.length);
      setState(() {
        _cimas = _cima[iC];
      });
    }
    if (_baixo.isNotEmpty) {
      int iB = alea.nextInt(_baixo.length);
      setState(() {
        _baixos = _baixo[iB];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  PhosphorIcons.bold.caretLeft,
                  size: 40.0,
                  color: um,
                ),
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: _cimas != null ? Color(int.parse(_cimas!['cor'].substring(1), radix: 16)) : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _cimas != null
                      ? Image.network(_cimas!['imagem'])
                      : Placeholder(),
                ),

                Icon(
                  PhosphorIcons.bold.caretRight,
                  size: 40.0,
                  color: um,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  PhosphorIcons.bold.caretLeft,
                  size: 40.0,
                  color: um,
                ),
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: _baixos != null ? Color(int.parse(_baixos!['cor'].substring(1), radix: 16)) : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _baixos != null
                      ? Image.network(_baixos!['imagem'])
                      : Placeholder(),
                ),

                Icon(
                  PhosphorIcons.bold.caretRight,
                  size: 40.0,
                  color: um,
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: tres,
                foregroundColor: dois,
                minimumSize: Size(50, 75),
              ),
              onPressed: aleatorio,
              child: Icon(
                PhosphorIcons.regular.shuffle,
                size: 30.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
