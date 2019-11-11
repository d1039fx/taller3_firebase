import 'package:flutter/material.dart';
import 'package:taller3_firebase/sign-in.dart';
import 'package:taller3_firebase/usuario.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  IngresoUsuarioEmail _ingresoUsuarioEmail = IngresoUsuarioEmail();
  String _idUsuario;

  bool _usuarioValido;

  TextFormField entradaDatos(
      {TextEditingController entrada, String nombreCampo}) {
    return TextFormField(
      controller: entrada,
      decoration: InputDecoration(labelText: nombreCampo),
      validator: nombreCampo == 'email'
          ? emailValidator
          : (valor) {
              if (valor.isEmpty) {
                return 'El campo esta vacio';
              }
              return null;
            },
      obscureText: nombreCampo == 'email' ? false : true,
    );
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'El formato del Email es invalido';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            entradaDatos(entrada: _email, nombreCampo: 'email'),
            entradaDatos(entrada: _password, nombreCampo: 'password'),
            _usuarioValido == false
                ? Text('Usuario o password invalido')
                : Text(''),
            RaisedButton.icon(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _ingresoUsuarioEmail
                        .loginConEmail(
                            email: _email.text, password: _password.text)
                        .then((usuario) {
                      setState(() {
                        _idUsuario = usuario.uid;
                      });
                    }).whenComplete(() {
                      if (_idUsuario == null) {
                        setState(() {
                          _usuarioValido = false;
                        });
                      } else {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => Usuario(
                                  id: _idUsuario,
                                )));
                      }
                    }).catchError((error) {
                      print('Error: $error');
                    });
                  }
                },
                icon: Icon(Icons.send),
                label: Text('Ingresar'))
          ],
        ));
  }
}
