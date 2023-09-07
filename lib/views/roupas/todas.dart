import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../colors.dart';
import '../../services/auth_service.dart';
import '../entrada/inicio.dart';


class Todas extends StatefulWidget {
  @override
  _TodasState createState() => _TodasState();
}

class _TodasState extends State<Todas> {
  List<Map<String, dynamic>> _roupas = [];
  String userId = '';

  @override
  void initState() {
    super.initState();
    carregarRoupas();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService authService = AuthService();

  Future<void> carregarRoupas() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        userId = user.uid;
        QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('roupas')
            .where('userId', isEqualTo: userId)
            .get();
        List<Map<String, dynamic>> roupas =
        snapshot.docs.map((doc) => doc.data()).toList();

        setState(() {
          _roupas = roupas;
        });
      }
    } catch (e) {
      print('Erro ao carregar as roupas: $e');
    }
  }

  Future<void> sair() async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deseja fazer o logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar', style: TextStyle(color: tres)),
            ),
            TextButton(
              onPressed: () async {
                await  authService.logout(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Principal()));

              },
              child: const Text('Sair', style: TextStyle(color: tres)),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: um,
        actions: <Widget>[
          IconButton(
      icon:Icon(
        PhosphorIcons.regular.signOut,
        size: 30.0,
      ),
            onPressed:sair,
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
            ),
            itemBuilder: (context, index) {
              if (index >= _roupas.length) {
                return Container();
              }

              Map<String, dynamic> roupa = _roupas[index];
              String imageUrl = roupa['imagem'];

              return Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
            itemCount: _roupas.length,
          ),
        ),
      ),
    );
  }
}
