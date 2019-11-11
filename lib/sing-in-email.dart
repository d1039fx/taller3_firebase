import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:taller3_firebase/usuario.dart';
import 'package:image_picker/image_picker.dart';

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
  File _file;

  FirebaseAuth _auth = FirebaseAuth.instance;

  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _passwordRepetido = TextEditingController();
  TextEditingController _nombre = TextEditingController();
  TextEditingController _apellido = TextEditingController();
  TextEditingController _cedula = TextEditingController();

  String email;
  String id;
  String nombre;
  String apellido;
  String cedula;
  String urlImagen;

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

  Future<FirebaseUser> registrarUsuario(
      {String emailUsuario, String passwordUsuario}) async {
    final FirebaseUser firebaseUser =
        (await _auth.createUserWithEmailAndPassword(
                email: emailUsuario, password: passwordUsuario))
            .user;
    return firebaseUser;
  }

  Future<File> _imagenUsuario() async {
    File imagen = await ImagePicker.pickImage(source: ImageSource.gallery);
    return imagen;
  }

  Future<String> uploadImage(File image) async {
    StorageReference reference =
        FirebaseStorage.instance.ref().child(image.path.toString());
    StorageUploadTask uploadTask = reference.putFile(image);

    StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);

    String url = (await downloadUrl.ref.getDownloadURL());
    return url;
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
    return SingleChildScrollView(
      child: Form(
          key: _globalKey,
          child: Column(
            children: <Widget>[
              campos(
                  helper: 'ingresar email',
                  nombreCampo: 'email',
                  tipoTeclado: TextInputType.emailAddress,
                  input: _email),
              campos(
                  helper: 'ingresar nombre',
                  nombreCampo: 'nombre',
                  tipoTeclado: TextInputType.text,
                  input: _nombre),
              campos(
                  helper: 'ingresar apellido',
                  nombreCampo: 'apellido',
                  tipoTeclado: TextInputType.text,
                  input: _apellido),
              campos(
                  input: _cedula,
                  tipoTeclado: TextInputType.number,
                  nombreCampo: 'cedula',
                  helper: 'ingresar cedula'),
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
              RaisedButton.icon(
                  onPressed: () => _imagenUsuario().then((imagen) {
                        setState(() {
                          _file = imagen;
                        });
                        uploadImage(imagen).then((url) {
                          setState(() {
                            urlImagen = url;
                          });
                        });
                      }).catchError((error) {
                        print('Error: $error');
                      }),
                  icon: Icon(Icons.camera),
                  label: Text('foto usuario')),
              _file == null ? Text('imagen usuario') : Image.file(_file),
              RaisedButton(
                child: Text('Crear usuario'),
                onPressed: () {
                  if (_globalKey.currentState.validate()) {
                    registrarUsuario(
                            emailUsuario: _email.text,
                            passwordUsuario: _passwordRepetido.text)
                        .then((usuario) {
                      setState(() {
                        email = usuario.email;
                        id = usuario.uid;
                        nombre = _nombre.text;
                        apellido = _apellido.text;
                        cedula = _cedula.text;
                      });
                    }).whenComplete(() {
                      Firestore.instance
                          .collection('usuario')
                          .document(id)
                          .setData({
                        'nombre': nombre,
                        'apellido': apellido,
                        'email': email,
                        'id': id,
                        'cedula': cedula
                      }).whenComplete(() {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Usuario(
                                      id: id,
                                    )));
                      }).catchError((error) {
                        print('Error: $error');
                      });

                      /*Firestore.instance
                          .collection('usuario')
                          .document(id)
                          .setData({
                        'nombre': nombre,
                        'apellido': apellido,
                        'url': urlImagen
                      }).whenComplete(() {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => Usuario(
                                  id: id,
                                )));
                      }).catchError((error) {
                        print('error $error');
                      });*/
                    }).catchError((error) {
                      print('Error: $error');
                    });
                  }
                },
              )
            ],
          )),
    );
  }
}
