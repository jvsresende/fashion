import 'package:firebase/views/roupas/menu.dart';
import 'package:firebase/views/roupas/todas.dart';
import 'package:firebase/views/entrada/inicio.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();

    //espera 3 segundos do splash
    Future.delayed(Duration(seconds: 3)).then((_) {
      //muda para a proxima tela
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Principal()));
    });
  }


  //constroe a tela do splash
  Widget build(BuildContext context) {
    return Container(
      color: um,
      alignment: Alignment.center,
      child: Center(
        child: CircularProgressIndicator(color: Colors.white,),
      ),
    );
  }
}
