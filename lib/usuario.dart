import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taller3_firebase/editar_item.dart';
import 'package:taller3_firebase/inicio.dart';
import 'package:taller3_firebase/items.dart';

class Usuario extends StatelessWidget {
  final String id;

  const Usuario({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => FirebaseAuth.instance.signOut().whenComplete(() {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }))
        ],
      ),
      body: ContenidoUsuario(
        id: id,
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Items(
                    idUsuario: id,
                  )))),
    );
  }
}

class Prueba extends StatefulWidget {
  final String id;

  const Prueba({Key key, this.id}) : super(key: key);

  @override
  _PruebaState createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('usuario')
            .document(widget.id)
            .collection('items')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snashot) {
          switch (snashot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            default:
              return ListView.builder(
                  itemCount: snashot.data.documents.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snashot.data.documents[index]['nombre']),
                      subtitle:
                          Text(snashot.data.documents[index]['descripcion']),
                    );
                  });
          }
        });
  }
}

class ContenidoUsuario extends StatefulWidget {
  final String id;

  const ContenidoUsuario({Key key, this.id}) : super(key: key);

  @override
  _ContenidoUsuarioState createState() => _ContenidoUsuarioState();
}

class _ContenidoUsuarioState extends State<ContenidoUsuario> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('usuario')
            .document(widget.id)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text('error ${snapshot.error}'),
            );
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            default:
              return Column(
                children: <Widget>[
                  Text(snapshot.data['cedula']),
                  snapshot.data['apellido'] == null
                      ? Container()
                      : Text(snapshot.data['apellido']),
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('usuario')
                              .document(widget.id)
                              .collection('items')
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snashot) {
                            if (snashot.hasError)
                              return Center(
                                child: Text('Error ${snashot.error}'),
                              );
                            switch (snashot.connectionState) {
                              case ConnectionState.waiting:
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                                break;
                              default:
                                return ListView.builder(
                                    itemCount: snashot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot doc =
                                          snashot.data.documents[index];
                                      return ListTile(
                                        trailing: Container(
                                          width: 100,
                                          child: Row(
                                            children: <Widget>[
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: Colors.green,
                                                  ),
                                                  onPressed: () => Navigator.of(
                                                          context)
                                                      .push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              Editar(
                                                                id: widget.id,
                                                                nombre: doc[
                                                                    'nombre'],
                                                                descripcion: doc[
                                                                    'descripcion'],
                                                                documento: doc
                                                                    .documentID,
                                                              )))),
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () => Firestore
                                                      .instance
                                                      .collection('usuario')
                                                      .document(widget.id)
                                                      .collection('items')
                                                      .document(snashot
                                                          .data
                                                          .documents[index]
                                                          .documentID)
                                                      .delete())
                                            ],
                                          ),
                                        ),
                                        title: Text(snashot
                                            .data.documents[index]['nombre']),
                                        subtitle: Text(snashot.data
                                            .documents[index]['descripcion']),
                                      );
                                    });
                            }
                          }))
                ],
              );
          }
        });
  }
}
