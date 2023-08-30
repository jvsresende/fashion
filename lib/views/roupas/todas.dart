import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../colors.dart'; // Importe o arquivo com as configurações do Firestore (verifique o nome correto)

class Todas extends StatefulWidget {
  @override
  _TodasState createState() => _TodasState();
}

class _TodasState extends State<Todas> {
  // Crie uma lista para armazenar os dados das roupas
  List<Map<String, dynamic>> _roupas = [];
  String userId = '';

  @override
  void initState() {
    super.initState();

    carregarRoupas();
  }
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> carregarRoupas() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        userId = user.uid; // Obtém o ID do usuário logado
        // Acessa a coleção "roupas" no Firestore e filtra pelo ID do usuário
        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
            .instance
            .collection('roupas')
            .where('userId', isEqualTo: userId)
            .get();
      // Converte os documentos do snapshot em uma lista de Map
      List<Map<String, dynamic>> roupas =
      snapshot.docs.map((doc) => doc.data()).toList();

      // Atualiza o estado da lista de roupas com os dados recuperados
      setState(() {
        _roupas = roupas;
      });};
    } catch (e) {
      print('Erro ao carregar as roupas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(

          width: MediaQuery.of(context).size.width, // Largura total da tela
          child: GridView.builder(

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // Espaçamento vertical entre os itens
              crossAxisSpacing: 10.0, // Espaçamento horizontal entre os itens
            ),
            itemBuilder: (context, index) {

              if (index >= _roupas.length) {
                return Container(); // Retorna um container vazio se não houver dados suficientes
              }

              Map<String, dynamic> roupa = _roupas[index];

              // Obtenha a URL da imagem da roupa
              String imageUrl = roupa['imagem'];

              return Padding(
                
                padding: EdgeInsets.only(top: 10.0), // Espaçamento do topo
                child: Container(
                  width: 200, // Largura fixa para a imagem
                  height: 200,
                  // Altura fixa para a imagem
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), // Borda arredondada
              ),
              child: ClipRRect( // ClipRRect para garantir que a imagem também tenha bordas arredondadas
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
              imageUrl,
              fit: BoxFit.cover, // Ajusta a imagem para preencher o container
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
