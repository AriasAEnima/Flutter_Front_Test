import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartjsp_prueba_front/Model/Usuario.dart';
import 'package:smartjsp_prueba_front/Screens/registrarUsuario.dart';
import 'actualizarUsuario.dart';
import 'obtenerUsuarios.dart';

class EliminarUsuario extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EliminarUsuarioState();
  }
}

Future<UserModel> eliminarUsuario(UserModel duser, BuildContext context) async {
  var Url = 'http://localhost:8080/api/service/users/${duser.id}';
  var response = await http.delete(
    Url,
    headers: <String, String>{
      "Content-Type": "application/json;charset=UTF-8,"
    },
  );
  if (response.statusCode == 200) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
              title: 'Se eliminó el usuario de la Aplicacion',
              content: duser.nombre + " " + duser.apellido);
        });
    return new UserModel();
  }
}

class EliminarUsuarioState extends State<EliminarUsuario> {
  @override
  Widget build(BuildContext context) {
    return ObtenerUsuarios();
  }
}
