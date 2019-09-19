import 'package:flutter/material.dart';
import 'package:controller/menu_listas.dart';
import 'package:controller/controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sistema controller'),
        ),
        body: Login(),
      ),
    );
  }
}

class Login extends StatefulWidget {
  @override
  LoginState createState() {
    return LoginState();
  }
}

class LoginState extends State<Login>{
  final _formKey = GlobalKey<FormState>();

  var usuario = TextEditingController();
  var senha = TextEditingController();
  ControllerService service = ControllerService();

/*
@override
  initState() {
      super.initState();
      service.autenticar("root", "\$pass+rt@28").then((autentica){
        if(autentica){
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Menu()),
          );
        }
      }); //$pass+rt@27        
  }*/

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usuario.dispose();
    senha.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: usuario,
            
            decoration: const InputDecoration(labelText: 'Usuario'),
            keyboardType: TextInputType.text,
            validator: (usuario) {
              
              if (usuario.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },            
          ),
          TextFormField(
            controller: senha,
            decoration: const InputDecoration(labelText: 'Senha'),
            obscureText: true,
            keyboardType: TextInputType.text,
            validator: (senha) {
              if (senha.isEmpty) {
                return 'Please enter some text';
              }
              return null;              
            },
            
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: RaisedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                    bool autentica = await service.autenticar(usuario.text,senha.text); //$pass+rt@27
                  if(autentica){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Menu()),
                    );
                  }
                  
                }
              },
              child: Text('Login'),
            ),
            )
            
          ),
        ],
      ),
    );
  }
}