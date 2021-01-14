import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smartjsp_prueba_front/Model/Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:smartjsp_prueba_front/Screens/registrarUsuario.dart';

import 'eliminarUsuario.dart';
import 'obtenerUsuarios.dart';

class ActualizarUsuario extends StatefulWidget {
  UserModel user;
  @override
  State<StatefulWidget> createState() {
    return ActualizarUsuarioState(user);
  }

  ActualizarUsuario(this.user);
}

Future<UserModel> getUsuario(BigInt documento) async {
  var response =
      await http.get('http://localhost:8080/api/service/users/${documento}');
  String bodye = utf8.decode(response.bodyBytes);
  var myModel = json.decode(bodye);
  if (response.statusCode == 200) {
    UserModel user = parseUserModel(myModel);
    return user;
  }
}

Future<UserModel> actualizarUsuario(
    BigInt id,
    String nombre,
    String apellido,
    String nacionalidad,
    String tipoDocumento,
    BigInt documento,
    String email,
    String telefono,
    String observaciones,
    BuildContext context) async {
  var Url = "http://localhost:8080/api/service/users/${id}";
  var response = await http.put(Url,
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode(<String, dynamic>{
        "id": id.toString(),
        "nombre": nombre,
        "apellido": apellido,
        "nacionalidad": nacionalidad,
        "tipoDocumento": tipoDocumento,
        "documento": documento.toString(),
        "email": email,
        "telefono": telefono,
        "observaciones": observaciones,
      }));
  Future<UserModel> um = null;
  String contenido = "";

  if (response.statusCode == 200) {
    contenido = " Se ha modificado correctamente el usuario: " +
        nombre +
        " " +
        apellido;
    um = getUsuario(documento);
  } else if (response.statusCode == 400) {
    contenido =
        " Datos errorenos !!!  verifique los datos (el documento puede existir ya en otro usuario) ";
  } else {
    contenido =
        " Error desconocido !!!  verifique el estado del servidor o peticion. ";
  }
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogConext) {
      return MyAlertDialog(
          title: 'Respuesta de la Aplicacion', content: contenido);
    },
  );
  return um;
}

class ActualizarUsuarioState extends State<ActualizarUsuario> {
  UserModel usuario;
  ActualizarUsuarioState(this.usuario);

  BuildContext get context => null;

  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController documentoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController observacionesController = TextEditingController();

  String nacionalidad = null;
  String tipoDeDocumento = null;
  bool disabledTipo = true;

  List<DropdownMenuItem<String>> menuTipoDocumento = List();

  void llenarTiposDeDocumento(tipo) {
    setState(() {
      menuTipoDocumento = [];
      for (String key in tipo.keys) {
        menuTipoDocumento.add(DropdownMenuItem<String>(
            value: key,
            child: Center(
              child: Text(tipo[key]),
            )));
      }
    });
  }

  void nacionalidadCambia(valor) {
    print("Estoy Cambiando a: " + valor);
    setState(() {
      nacionalidad = valor;
      tipoDeDocumento = null;
      if (valor == "Colombiano") {
        llenarTiposDeDocumento(nativo);
      } else {
        llenarTiposDeDocumento(extrajero);
      }
      disabledTipo = false;
    });
  }

  void tipoDeDocumentoCambia(valor) {
    setState(() {
      tipoDeDocumento = valor;
    });
  }

  final minimoPadding = 5.0;
  final GlobalKey<FormState> _formKeyUp = GlobalKey<FormState>();

  void lleneCampos() {
    nombreController.text = usuario.nombre;
    apellidoController.text = usuario.apellido;
    nacionalidadCambia(usuario.nacionalidad);
    tipoDeDocumento = usuario.tipoDocumento;
    documentoController.text = usuario.documento.toString();
    emailController.text = usuario.email;
    telefonoController.text = usuario.telefono;
    observacionesController.text = usuario.observaciones;
  }

  void initState() {
    super.initState();
    lleneCampos();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle2;
    return Scaffold(
        appBar: AppBar(
          title: Text(usuario.nombre + " " + usuario.apellido),
        ),
        body: Container(
            child: Column(children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text(usuario.id.toString())),
                    DataCell(Text(usuario.nombre)),
                    DataCell(Text(usuario.apellido)),
                    DataCell(Text(usuario.nacionalidad)),
                    DataCell(Text(usuario.tipoDocumento)),
                    DataCell(Text(usuario.documento.toString())),
                    DataCell(Text(usuario.email)),
                    DataCell(Text(usuario.telefono)),
                    DataCell(Text(usuario.observaciones)),
                    DataCell(Text(usuario.fecha)),
                    DataCell(Text(usuario.estado)),
                  ],
                )
              ],
              columns: buildDataColumns(),
              showCheckboxColumn: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: ElevatedButton.icon(
              label: Text("Eliminar"),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MyAlertDialog(
                      title: "¿Esta seguro?",
                      content: "Quiere elimnar a: " +
                          usuario.nombre +
                          " " +
                          usuario.apellido,
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          child: Text("Cancelar"),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          child: Text("Continuar"),
                          onPressed: () {
                            eliminarUsuario(usuario, context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EliminarUsuario()));
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.delete,
                size: 50,
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKeyUp,
              child: Column(
                children: <Widget>[
                  ...formulario(
                      minimoPadding,
                      textStyle,
                      nombreController,
                      apellidoController,
                      tipoDeDocumentoCambia,
                      disabledTipo,
                      nacionalidadCambia,
                      tipoDeDocumento,
                      menuTipoDocumento,
                      nacionalidad,
                      documentoController,
                      emailController,
                      telefonoController,
                      observacionesController),
                  ElevatedButton.icon(
                      label: Text('Actualizar'),
                      icon: Icon(Icons.edit, size: 50),
                      onPressed: () async {
                        if (_formKeyUp.currentState.validate()) {
                          UserModel usuarior = await actualizarUsuario(
                              usuario.id,
                              nombreController.text,
                              apellidoController.text,
                              nacionalidad,
                              tipoDeDocumento,
                              BigInt.parse(documentoController.text),
                              emailController.text,
                              telefonoController.text,
                              observacionesController.text,
                              context);
                          if (usuarior != null) {
                            setState(() {
                              usuario = usuarior;
                              lleneCampos();
                            });
                          }
                        }
                      })
                ],
              ),
            ),
          ),
        ])));
  }
}
