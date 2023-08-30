
import 'package:flutter/material.dart';
import 'package:firebase/colors.dart';
import 'package:firebase/views/roupas/todas.dart';
import 'package:firebase/views/roupas/escolha.dart';
import 'package:firebase/views/roupas/adicionar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';




//indice de seleção da tela
int _selectedIndex = 0;

//vetor de telas a serem utilizadas
List<Widget> _stOptions = <Widget>[
  Todas(),
  Adicionar(),
  Escolher(),
];

class Navegar extends StatefulWidget {
  int _opcao;

  //contrutor passando o indice da tela selecionada
  Navegar(this._opcao);

  @override
  _NavegarState createState() => _NavegarState(this._opcao);
}

class _NavegarState extends State<Navegar> {

  //construtor
  _NavegarState(this._opcao);
  int _opcao;

  @override
  void initState() {
    _selectedIndex = _opcao;
  }


  Widget build(BuildContext context) {
    return  Scaffold(
      //corpo da aplicação, aqui são setadas as telas
      body: _stOptions.elementAt(_selectedIndex),

      //botões do BN
    bottomNavigationBar: BottomNavigationBar(
        backgroundColor: um,
      showUnselectedLabels: false,
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:Icon(
              PhosphorIcons.regular.coatHanger,
              size: 30.0,
            ),
            label: 'Roupas',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              PhosphorIcons.regular.plusCircle,
              size:30.0,
            ),
            label: 'Adicionar',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              PhosphorIcons.regular.shuffle,
              size:30.0,
            ),
            label: 'Aleatório',
          ),
        ],

        unselectedItemColor: Colors.white38,

        currentIndex: _selectedIndex,

        selectedItemColor: dois,
        //greenAccent,
        onTap:
        _onItemTapped, //chama o métdodo onItemTapped ao clicar no botao do BTNNavigation
      ),
    );
  }

  @override
  void _onItemTapped(int  index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}