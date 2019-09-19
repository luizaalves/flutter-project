
import 'dart:async';

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

  @override
  Widget build(BuildContext context) {

    var futureBuilderPagar = new FutureBuilder(
      future: _getData(0),
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
      future: _getData(1),
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
  int _selectedIndex = 0;

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
      appBar: new AppBar(
        title: new Text("Lista de contas"),
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

  Future<List<String>> _getData(index) async {
    ControllerService service = ControllerService();

    await service.autenticar("root", "\$pass+rt@28");

    var values;
    if (index == 0) {
      values = await service.contasPagar(0, 15);
    }
    else values = await service.contasReceber(0, 15);

    List<String> itens = [];
    if(values!=null) {
      for(int i=0;i<values.length-1;i++){
        String saldo = values[i].valor.toString();
        if(index == 0) saldo = saldo.substring(1);
        itens.add('Nome: ${values[i].colaborador.razaoSocial}\nValor: R\$ $saldo');
      }
    }
    return itens;
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<String> values = snapshot.data;
    return new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return new Column(
            children: <Widget>[
              new ListTile(
                title: new Text(values[index]),
              ),
              new Divider(height: 2.0,),
            ],
          );
        },
    );
  }
}