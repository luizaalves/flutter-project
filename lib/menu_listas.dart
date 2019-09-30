
import 'dart:async';
import 'dart:core';
import 'package:controller/login.dart';
import 'package:controller/model.dart';
import 'package:flutter/material.dart';
import 'package:controller/controller.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Menu(),
    );
  }
}

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => new _MenuState();
}

class _MenuState extends State<Menu> {
  ControllerService service = ControllerService();
  static const int _BUSCAR_CONTAS_RECEBER=1,_BUSCAR_CONTAS_PAGAR=0;
  
  int _selectedIndex = _BUSCAR_CONTAS_PAGAR;

  @override
  Widget build(BuildContext context) {
    var futureBuilderPagar = new FutureBuilder(
      future: _getData(_BUSCAR_CONTAS_PAGAR),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );

    var futureBuilderReceber = new FutureBuilder(
      future: _getData(_BUSCAR_CONTAS_RECEBER),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );
  

    List<Widget> _widgetOptions = <Widget>[
      futureBuilderPagar,
      futureBuilderReceber,
    ];
  
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Home"),
        actions: <Widget>[
          IconButton(
              icon: new Icon(Icons.power_settings_new),
              onPressed: () {
                Navigator.of(context).pop(Login());
              }
            )
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            title: Text('Contas a pagar'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            title: Text('Contas a receber'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Future<List<Lancamento>> _getData(index) async {
    if (index == _BUSCAR_CONTAS_PAGAR) {
     return service.contasPagar(0, 15);
    }else if(index == _BUSCAR_CONTAS_RECEBER) {
      return service.contasReceber(0, 15);
    } 
    return null;
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Lancamento> lancamentos = snapshot.data;
    return new ListView.builder(
        itemCount: lancamentos.length,
        itemBuilder: (BuildContext context, int index) {
          return new Column(
            children: <Widget>[
              new ListTile(
                title: new Text("${lancamentos[index].colaborador.razaoSocial}\n${lancamentos[index].valor.abs()}"),
              ),
              new Divider(height: 2.0,),
            ],
          );
        },
    );
  }
}