import 'package:flutter/material.dart';
import 'package:controller/menu_listas.dart';
import 'package:controller/controller.dart';

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sistema controller',
            style: new TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold
            ),
          textAlign: TextAlign.center,
          ),
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

  @override
  void dispose() {
    super.dispose();
    usuario.dispose();
    senha.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 30.0),
            child: new TextFormField(
              controller: usuario,
              autofocus: false,
              decoration: new InputDecoration(
                  prefixIcon: 
                    Icon(
                      const IconData(59389, fontFamily: 'MaterialIcons')
                    ),
                  labelText: 'Usuário',
                  ),
              keyboardType: TextInputType.text,
              validator: (usuario) {
                if (usuario.isEmpty) {
                  return 'Please enter some text';
                }
                return null;              
              },
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0,top: 10.0),
            child: new TextFormField(
              controller: senha,
              obscureText: true,
              decoration: new InputDecoration(
                prefixIcon: 
                  Icon(
                    const IconData(57562, fontFamily: 'MaterialIcons')
                  ),
                labelText: 'Senha',
              ),
              keyboardType: TextInputType.text,
              validator: (senha) {
                if (senha.isEmpty) {
                  return 'Please enter some text';
                }
                return null;              
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 0.0, top: 45.0, bottom: 20.0),
            child: Center(
              child: new RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius:
                    new BorderRadius.circular(30.0)),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                    bool autentica = await service.autenticar(usuario.value.text.toString(),senha.value.text.toString());
                  if(autentica){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Menu()),
                    );
                  }
                  else {
                    /////////
                  }
                }
              },
              child: new Text(
                "Login",
                style: new TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
                ),
              color: Color(0xFF54C5F8),
              textColor: Colors.white,
              elevation: 5.0,
              padding: EdgeInsets.only(
                  left: 80.0,
                  right: 80.0,
                  top: 15.0,
                  bottom: 15.0),
              ),
            )
          ),
        ],
      ),
    );
  }
  
}
