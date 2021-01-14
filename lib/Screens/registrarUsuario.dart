import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:smartjsp_prueba_front/Model/Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';

class RegistrarUsuario extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegistrarUsuarioState();
  }
}

Future<UserModel> registrarUsuario(
    String nombre,
    String apellido,
    String nacionalidad,
    String tipoDocumento,
    BigInt documento,
    String email,
    String telefono,
    String observaciones,
    BuildContext context) async {
  var Url = "http://localhost:8080/api/service/newuser";
  var response = await http.post(Url,
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode(<String, dynamic>{
        "nombre": nombre,
        "apellido": apellido,
        "nacionalidad": nacionalidad,
        "tipoDocumento": tipoDocumento,
        "documento": documento.toString(),
        "email": email,
        "telefono": telefono,
        "observaciones": observaciones,
      }));
  String contenido = "";

  if (response.statusCode == 200) {
    contenido =
        " Se ha agregado correctamente el usuario: " + nombre + " " + apellido;
  } else if (response.statusCode == 400) {
    contenido =
        " Datos errorenos !!!  verifique los datos (el documento puede existir ya) ";
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
}

final extrajero = {
  "Cedula de extrajería": "Cedula de extrajería",
  "Pasaporte": "Pasaporte"
};
final nativo = {"Cedula de cuidadanía": "Cedula de cuidadanía"};

class RegistrarUsuarioState extends State<RegistrarUsuario> {
  final minimoPadding = 5.0;

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

  void nacionalidadCambia(_value) {
    setState(() {
      nacionalidad = _value;
      tipoDeDocumento = null;
      if (_value == "Colombiano") {
        llenarTiposDeDocumento(nativo);
      } else {
        llenarTiposDeDocumento(extrajero);
      }
      disabledTipo = false;
    });
  }

  void tipoDeDocumentoCambia(_value) {
    setState(() {
      tipoDeDocumento = _value;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle2;
    return Scaffold(
        appBar: AppBar(
          title: Text("Registrar Usuario"),
        ),
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              constraints: BoxConstraints(maxWidth: 500),
              child: Form(
                  key: _formKey,
                  child: Padding(
                      padding: EdgeInsets.all(minimoPadding * 2),
                      child: ListView(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  top: minimoPadding, bottom: minimoPadding),
                              child: Icon(Icons.supervised_user_circle_outlined,
                                  size: 200)),
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
                          ElevatedButton(
                              child: Text('Registrar'),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  UserModel usuarior = await registrarUsuario(
                                      nombreController.text,
                                      apellidoController.text,
                                      nacionalidad,
                                      tipoDeDocumento,
                                      BigInt.parse(documentoController.text),
                                      emailController.text,
                                      telefonoController.text,
                                      observacionesController.text,
                                      context);
                                  nombreController.text = '';
                                  apellidoController.text = '';
                                  nacionalidad = null;
                                  tipoDeDocumento = null;
                                  documentoController.text = null;
                                  emailController.text = '';
                                  telefonoController.text = '';
                                  observacionesController.text = '';
                                }
                              })
                        ],
                      )))),
        ));
  }
}

List<Widget> formulario(
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
    observacionesController) {
  return [
    Padding(
        padding: EdgeInsets.only(top: minimoPadding, bottom: minimoPadding),
        child: TextFormField(
          style: textStyle,
          controller: nombreController,
          validator: (String value) {
            if (value.isEmpty) {
              return "Por favor llene el campo de nombre";
            }
          },
          decoration: InputDecoration(
              labelText: 'Nombre(s)',
              hintText: 'Ingrese su(s) nombre(s)',
              labelStyle: textStyle,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        )),
    Padding(
        padding: EdgeInsets.only(top: minimoPadding, bottom: minimoPadding),
        child: TextFormField(
          style: textStyle,
          controller: apellidoController,
          validator: (String value) {
            if (value.isEmpty) {
              return "Por favor llene el campo de apellido";
            }
            return null;
          },
          decoration: InputDecoration(
              labelText: 'Apellido(s)',
              hintText: 'Ingrese su(s) apellido(s)',
              labelStyle: textStyle,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        )),
    Padding(
      padding: EdgeInsets.only(top: minimoPadding, bottom: minimoPadding),
      child: DropdownButtonFormField<String>(
        value: nacionalidad,
        items: [
          DropdownMenuItem<String>(
            value: "Colombiano",
            child: Center(
              child: Text("Colombiano"),
            ),
          ),
          DropdownMenuItem<String>(
            value: "Argentino",
            child: Center(
              child: Text("Argentino"),
            ),
          ),
          DropdownMenuItem<String>(
            value: "Español",
            child: Center(
              child: Text("Español"),
            ),
          )
        ],
        isExpanded: true,
        hint: Text("Escoja su Nacionalidad"),
        onChanged: (_value) => nacionalidadCambia(_value),
      ),
    ),
    Padding(
      padding: EdgeInsets.only(top: minimoPadding, bottom: minimoPadding),
      child: DropdownButtonFormField(
        value: tipoDeDocumento,
        items: menuTipoDocumento,
        disabledHint: Text("Primero Escoja su Nacionalidad"),
        isExpanded: true,
        hint: Text("Escoja su Tipo de Documento"),
        onChanged:
            disabledTipo ? null : (_value) => tipoDeDocumentoCambia(_value),
      ),
    ),
    Padding(
        padding: EdgeInsets.only(top: minimoPadding, bottom: minimoPadding),
        child: TextFormField(
          style: textStyle,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
          ],
          controller: documentoController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Por favor llene el campo de documento";
            }
            return null;
          },
          decoration: InputDecoration(
              labelText: 'Documento',
              hintText: 'Ingrese su documento',
              labelStyle: textStyle,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        )),
    Padding(
        padding: EdgeInsets.only(top: minimoPadding, bottom: minimoPadding),
        child: TextFormField(
          style: textStyle,
          controller: emailController,
          validator: (value) => EmailValidator.validate(value)
              ? null
              : "Por favor ingrese un email valido",
          decoration: InputDecoration(
              labelText: 'Correo',
              hintText: 'Ingrese su correo',
              labelStyle: textStyle,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        )),
    Padding(
        padding: EdgeInsets.only(top: minimoPadding, bottom: minimoPadding),
        child: TextFormField(
          keyboardType: TextInputType.phone,
          controller: telefonoController,
          validator: (String value) {
            if (value == null || value.isEmpty) {
              return "Por favor llene el campo de telefono";
            }
            return null;
          },
          decoration: InputDecoration(
              labelText: 'Telefono',
              hintText: 'Ingrese su telefono',
              labelStyle: textStyle,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        )),
    Container(
        margin: EdgeInsets.all(12),
        height: 5 * 24.0,
        child: TextFormField(
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          controller: observacionesController,
          decoration: InputDecoration(
              labelText: 'Observaciones',
              hintText: 'Observaciones (opcional)',
              labelStyle: textStyle,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        )),
  ];
}

class MyAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  MyAlertDialog({
    this.title,
    this.content,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          this.title,
          style: Theme.of(context).textTheme.title,
        ),
        actions: this.actions,
        content: Text(
          this.content,
          style: Theme.of(context).textTheme.body1,
        ));
  }
}
