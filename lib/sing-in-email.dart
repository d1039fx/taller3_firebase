import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistroUsuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de usuario'),
      ),
      body: Formulario(),
    );
  }
}

class Formulario extends StatefulWidget {
  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _passwordRepetido = TextEditingController();

  String email;
  String id;

  TextFormField campos(
      {TextEditingController input,
      TextInputType tipoTeclado,
      String nombreCampo,
      String helper}) {
    return TextFormField(
      controller: input,
      decoration: InputDecoration(labelText: nombreCampo, helperText: helper),
      keyboardType: tipoTeclado,
      validator: nombreCampo == 'email'
          ? emailValidator
          : (valor) {
              if (valor.isEmpty) {
                return 'El campo esta vacio';
              } else if (nombreCampo == 'repetir password') {
                if (_password.text != _passwordRepetido.text) {
                  return 'no coincide el password';
                }
              }
              return null;
            },
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

  Future<FirebaseUser> registrarUsuario({String emailUsuario, String passwordUsuario}) async{

    final FirebaseUser firebaseUser = (await _auth.createUserWithEmailAndPassword(email: emailUsuario, password: passwordUsuario)).user;
    return firebaseUser;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = '';
    id = '';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
        child: Column(
      children: <Widget>[
        campos(
            helper: 'ingresar email',
            nombreCampo: 'email',
            tipoTeclado: TextInputType.emailAddress,
            input: _email),
        campos(
            helper: 'ingresar password',
            nombreCampo: 'password',
            tipoTeclado: TextInputType.visiblePassword,
            input: _password),
        campos(
            helper: 'ingresar repetir password',
            nombreCampo: 'repetir password',
            tipoTeclado: TextInputType.visiblePassword,
            input: _passwordRepetido),
        RaisedButton(
          child: Text('Crear usuario'),
          onPressed: () {
            if(_globalKey.currentState.validate()){
              registrarUsuario(emailUsuario: _email.text, passwordUsuario: _passwordRepetido.text).then((usuario){
                setState(() {
                  email = usuario.email;
                  id = usuario.uid;
                });
              }).whenComplete((){
                print('email: $email, id usuario: $id');
              }).catchError((error){
                print('Error: $error');
              });
            }
          },
        )
      ],
    ));
  }
}
