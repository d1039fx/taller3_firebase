import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Items extends StatelessWidget {
  final String idUsuario;

  const Items({Key key, this.idUsuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items nuevos'),
      ),
      body: IngresoItems(
        id: idUsuario,
      ),
    );
  }
}

class IngresoItems extends StatefulWidget {
  final String id;

  const IngresoItems({Key key, this.id}) : super(key: key);

  @override
  _IngresoItemsState createState() => _IngresoItemsState();
}

class _IngresoItemsState extends State<IngresoItems> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  TextEditingController _nombreItem = TextEditingController();
  TextEditingController _descripcion = TextEditingController();

  String nombre, descripcion;

  TextFormField campos(
      {TextEditingController input,
      TextInputType tipoTeclado,
      String nombreCampo,
      String helper}) {
    return TextFormField(
        controller: input,
        decoration: InputDecoration(labelText: nombreCampo, helperText: helper),
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
    return SingleChildScrollView(
      child: Form(
          key: _globalKey,
          child: Column(
            children: <Widget>[
              campos(
                  helper: 'ingrese nombre',
                  nombreCampo: 'nombre',
                  tipoTeclado: TextInputType.text,
                  input: _nombreItem),
              campos(
                  helper: 'ingrese descripcion',
                  nombreCampo: 'descripcion',
                  tipoTeclado: TextInputType.text,
                  input: _descripcion),
              RaisedButton.icon(
                  onPressed: () {
                    if (_globalKey.currentState.validate()) {
                      Firestore.instance
                          .collection('usuario')
                          .document(widget.id)
                          .collection('items')
                          .document()
                          .setData({
                        'nombre': _nombreItem.text,
                        'descripcion': _descripcion.text
                      }).whenComplete(() {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text('Guardar'))
            ],
          )),
    );
  }
}
