import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Editar extends StatelessWidget {
  final String id;
  final String nombre;
  final String descripcion;
  final String documento;

  const Editar(
      {Key key, this.id, this.nombre, this.descripcion, this.documento})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar item'),
      ),
      body: EditarItem(
        id: id,
        descripcion: descripcion,
        nombre: nombre,
        documento: documento,
      ),
    );
  }
}

class EditarItem extends StatefulWidget {
  final String id;
  final String nombre;
  final String descripcion;
  final String documento;

  const EditarItem(
      {Key key, this.id, this.descripcion, this.nombre, this.documento})
      : super(key: key);

  @override
  _EditarItemState createState() => _EditarItemState();
}

class _EditarItemState extends State<EditarItem> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  TextEditingController _nombreItem = TextEditingController();
  TextEditingController _descripcion = TextEditingController();

  String nombre, descripcion;

  TextFormField campos(
      {TextEditingController input,
      TextInputType tipoTeclado,
      String nombreCampo,
      String helper,
      String valorAnterior}) {
    return TextFormField(
        controller: input,
        decoration: InputDecoration(
            labelText: nombreCampo,
            helperText: helper,
            hintText: valorAnterior),
        keyboardType: tipoTeclado,
        validator: (valor) {
          if (valor.isEmpty) {
            return 'El campo esta vacio';
          }
          return null;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _globalKey,
        child: Column(
          children: <Widget>[
            campos(
                helper: 'ingrese nombre',
                nombreCampo: 'nombre',
                tipoTeclado: TextInputType.text,
                input: _nombreItem,
                valorAnterior: widget.nombre),
            campos(
                helper: 'ingrese descripcion',
                nombreCampo: 'descripcion',
                tipoTeclado: TextInputType.text,
                input: _descripcion,
                valorAnterior: widget.descripcion),
            RaisedButton.icon(
                onPressed: () {
                  if (_globalKey.currentState.validate()) {
                    Firestore.instance
                        .collection('usuario')
                        .document(widget.id)
                        .collection('items')
                        .document(widget.documento)
                        .updateData({
                      'nombre': _nombreItem.text,
                      'descripcion': _descripcion.text
                    }).whenComplete(() {
                      Navigator.of(context).pop();
                    });
                  }
                },
                icon: Icon(Icons.edit),
                label: Text('Editar datos'))
          ],
        ));
  }
}
