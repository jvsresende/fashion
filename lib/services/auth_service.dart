import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../views/entrada/inicio.dart';
import '../views/roupas/menu.dart';

class AuthException implements Exception {
  String message;

  AuthException(this.message);
}

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService();

  _authCheck(BuildContext context) {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Principal(),
        ));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Navegar(0),
        ));
      }
    });
  }

  registrar(BuildContext context, String email, String senha) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este email já está cadastrado');
      }
    }
  }

  login(BuildContext context, String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Email não encontrado. Cadastre-se.');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta. Tente novamente');
      }
    }
  }

  logout(BuildContext context) async {
    await _auth.signOut();
  }
}
