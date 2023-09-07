import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../views/entrada/inicio.dart';
import '../views/roupas/menu.dart';

class AuthCheck extends StatefulWidget {
  AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Principal(),
        ));
      } else {
        // Usuário autenticado, navegue para a tela Todas
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Navegar(0),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
