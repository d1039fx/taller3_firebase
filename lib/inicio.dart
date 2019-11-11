import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taller3_firebase/login.dart';
import 'package:taller3_firebase/sign-in.dart';
import 'package:taller3_firebase/sing-in-email.dart';
import 'package:taller3_firebase/usuario.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio App'),
      ),
      body: ContenidoInicial(),
    );
  }
}

class ContenidoInicial extends StatelessWidget {
  final IngresoUsuario _ingresoUsuario = IngresoUsuario();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Login(),
          Container(
            alignment: Alignment.center,
            width: 200,
            height: 100,
            child: RaisedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'imagenes/icon.png',
                    height: 50,
                    width: 50,
                  ),
                  Text('Ingresar')
                ],
              ),
              onPressed: () =>
                  _ingresoUsuario.ingresoUsuariofuncion().then((usuario) {
                print(usuario.email);
                Firestore.instance
                    .collection('usuario')
                    .document(usuario.uid)
                    .setData({
                  'nombre': usuario.displayName,
                  'apellido': usuario.providerData.toString(),
                  'id': usuario.uid
                }).whenComplete(() {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Usuario(
                            id: usuario.uid,
                          )));
                });
              }).catchError((error) {
                print('Error: $error');
              }),
            ),
          ),
          FlatButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RegistroUsuario())),
              child: Text('Registrar usuario'))
        ],
      ),
    );
  }
}
