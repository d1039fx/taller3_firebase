import 'package:flutter/material.dart';
import 'package:taller3_firebase/sign-in.dart';
import 'package:taller3_firebase/sing-in-email.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          width: 200,
          height: 100,
          child: RaisedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('imagenes/icon.png', height: 50, width: 50,),
                Text('Ingresar')
              ],
            ),
            onPressed: () => _ingresoUsuario.ingresoUsuariofuncion().then((usuario){
              print(usuario.email);
            }).catchError((error){
              print('Error: $error');
            }),
          ),
        ),
        FlatButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegistroUsuario())), child: Text('Registrar usuario'))
      ],
    );
  }
}

