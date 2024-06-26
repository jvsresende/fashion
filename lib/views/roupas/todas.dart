import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  String? selecionar;
  String? filtro;

  @override
  void initState() {
    super.initState();
    carregarRoupas();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService authService = AuthService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> carregarRoupas() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        userId = user.uid;
        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
            .instance
            .collection('roupas')
            .where('userId', isEqualTo: userId)
            .where('categoria', isEqualTo: filtro)
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

  Future<void> sair() async {
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
                await authService.logout(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Principal()));
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
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            backgroundColor: um,
            automaticallyImplyLeading: false,
            expandedHeight: 0,
            title: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  PopupMenuButton<String>(
                    onSelected: (String escolha) {
                      if (escolha == '') {
                        filtro = null;
                        carregarRoupas();
                      } else {
                        filtro = escolha;
                        carregarRoupas();
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: '',
                          child: Text('Categoria/Resetar'),
                        ),
                        PopupMenuItem<String>(
                          value: 'bc',
                          child: Text('Blusa Manga Curta'),
                        ),
                        PopupMenuItem<String>(
                          value: 'bl',
                          child: Text('Blusa Manga Longa'),
                        ),
                        PopupMenuItem<String>(
                          value: 'r',
                          child: Text('Regata'),
                        ),
                        PopupMenuItem<String>(
                          value: 'j',
                          child: Text('Jaqueta'),
                        ),
                        PopupMenuItem<String>(
                          value: 'c',
                          child: Text('Casacos'),
                        ),
                        PopupMenuItem<String>(
                          value: 'b',
                          child: Text('Bermuda'),
                        ),
                        PopupMenuItem<String>(
                          value: 'ca',
                          child: Text('Calça'),
                        ),
                        PopupMenuItem<String>(
                          value: 's',
                          child: Text('Short'),
                        ),
                        PopupMenuItem<String>(
                          value: 'sa',
                          child: Text('Saia'),
                        ),
                        PopupMenuItem<String>(
                          value: 'v',
                          child: Text('Vestido'),
                        ),
                      ];
                    },
                    icon: Icon(
                      PhosphorIcons.regular.list,
                      size: 30.0,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      PhosphorIcons.regular.signOut,
                      size: 30.0,
                    ),
                    onPressed: sair,
                  ),
                ],
              ),
            ),
          )
        ],
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5.0,
            ),
            itemBuilder: (context, index) {
              if (index >= _roupas.length) {
                return Container();
              }
              Map<String, dynamic> roupa = _roupas[index];
              String imageUrl = roupa['imagem'];

              return GestureDetector(
                onTap: () {
                  String roupaId = _roupas[index]['id'];
                  print('Item $index foi tocado! ID do documento: $roupaId');
                },
                onLongPress: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Deseja Excluir esta Roupa?'),
                      content: const Text(
                          "A exclusão é permanente e não pode ser recuperada posteriormente"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancelar',
                              style: TextStyle(color: tres)),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Obter o id da roupa
                            String? roupaId = roupa['id'];

                            // Excluir a roupa do Cloud Firestore
                            await FirebaseFirestore.instance
                                .collection('roupas')
                                .doc(roupaId)
                                .delete();

                            // Excluir a imagem da roupa do Cloud Storage
                            var imageRef =
                                FirebaseStorage.instance.refFromURL(imageUrl);
                            await imageRef.delete();
                            carregarRoupas();
                            // Fechar o diálogo
                            Navigator.of(context).pop();
                          },
                          child: const Text('Excluir',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                ),
                child: Padding(
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
