import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartjsp_prueba_front/Model/Usuario.dart';
import 'package:smartjsp_prueba_front/Screens/actualizarUsuario.dart';
import 'package:smartjsp_prueba_front/Screens/usuariosDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ObtenerUsuarios extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ObtenerUsuariosActivos();
  }
}

UserModel parseUserModel(var e) {
  UserModel usuarion = new UserModel();
  usuarion.id = BigInt.parse("${e["id"]}");
  usuarion.nombre = "${e["nombre"]}";
  usuarion.apellido = "${e["apellido"]}";
  usuarion.nacionalidad = "${e["nacionalidad"]}";
  usuarion.tipoDocumento = "${e["tipoDocumento"]}";
  usuarion.documento = BigInt.parse("${e["documento"]}");
  usuarion.email = "${e["email"]}";
  usuarion.telefono = "${e["telefono"]}";
  usuarion.observaciones = "${e["observaciones"]}";
  usuarion.fecha = "${e["fecha"]}";
  usuarion.estado = "${e["estado"]}" == "true" ? "Activo" : "Inactivo";
  return usuarion;
}

class ObtenerUsuariosActivos extends State<ObtenerUsuarios> {
  UserModel filtro = new UserModel();
  TextEditingController nombreFiltroController = TextEditingController();
  TextEditingController apellidoFiltroController = TextEditingController();
  TextEditingController documentoFiltroController = TextEditingController();
  final minimoPadding = 5.0;

  Future<List<UserModel>> getUsuarios(UserModel filter) async {
    var data = await http.get('http://localhost:8080/api/service/users');
    String bodye = utf8.decode(data.bodyBytes);
    List myModels = json.decode(bodye);
    List<UserModel> usuariosl = [];
    for (var e in myModels) {
      usuariosl.add(parseUserModel(e));
    }
    print("Filtro: ${filter.nombre}" +
        " " +
        "${filter.apellido}" +
        " " +
        "${filter.documento}");
    return usuariosl
        .where((user) =>
            (filter.nombre == null ||
                user.nombre
                    .toLowerCase()
                    .contains(filter.nombre.toLowerCase())) &&
            (filter.documento == null || user.documento == filter.documento) &&
            (filter.apellido == null ||
                user.apellido
                    .toLowerCase()
                    .contains(filter.apellido.toLowerCase())))
        .toList();
  }

  DataRow buildDataRow(UserModel data) {
    return DataRow(
        cells: <DataCell>[
          DataCell(Text(data.id.toString())),
          DataCell(Text(data.nombre)),
          DataCell(Text(data.apellido)),
          DataCell(Text(data.nacionalidad)),
          DataCell(Text(data.tipoDocumento)),
          DataCell(Text(data.documento.toString())),
          DataCell(Text(data.email)),
          DataCell(Text(data.telefono)),
          DataCell(Text(data.observaciones)),
          DataCell(Text(data.fecha)),
          DataCell(Text(data.estado)),
        ],
        onSelectChanged: (bool selected) {
          if (selected) {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ActualizarUsuario(data)))
                .whenComplete(() {
              setState(() {});
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Usuarios Activos",
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                "Selecione un usuario para ver/modificar",
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              )
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {});

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UsuariosDrawer()));
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(7),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton.extended(
                    heroTag: 'FiltrarButton',
                    label: Text("Filtrar"),
                    onPressed: () {
                      createAlertDialog(context);
                    },
                    icon: Icon(Icons.filter_alt_rounded, size: 50),
                    backgroundColor: Colors.orange),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton.extended(
                    heroTag: 'MostrarTodosButton',
                    label: Text("Mostrar Todos"),
                    onPressed: () {
                      setState(() {
                        filtro = new UserModel();
                      });
                    },
                    icon: Icon(Icons.featured_play_list_outlined, size: 50),
                    backgroundColor: Colors.orange),
              ),
            ),
            Container(
              child: FutureBuilder(
                future: getUsuarios(filtro),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data != null && snapshot.data.length > 0) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        rows: <DataRow>[
                          for (int i = 0; i < snapshot.data.length; i++)
                            buildDataRow(snapshot.data[i]),
                        ],
                        columns: buildDataColumns(),
                        showCheckboxColumn: false,
                      ),
                    );
                  }
                  return Container(
                      child: Center(
                          child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error),
                      Text(
                        "No hay usuarios que cumplan con lo solicitado",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )));
                },
              ),
            ),
          ],
        ));
  }

  contentBox(context) {
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 300.0),
        child: Form(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                      top: minimoPadding, bottom: minimoPadding),
                  child: Text("Ingrese uno o mas parámetros")),
              Padding(
                  padding: EdgeInsets.only(
                      top: minimoPadding, bottom: minimoPadding),
                  child: TextFormField(
                    controller: nombreFiltroController,
                    decoration: InputDecoration(
                        labelText: 'Nombre(s)',
                        hintText: 'Filtrar por nombre(s)',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      top: minimoPadding, bottom: minimoPadding),
                  child: TextFormField(
                    controller: apellidoFiltroController,
                    decoration: InputDecoration(
                        labelText: 'Apellido(s)',
                        hintText: 'Filtrar por apellido(s)',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      top: minimoPadding, bottom: minimoPadding),
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    controller: documentoFiltroController,
                    decoration: InputDecoration(
                        labelText: 'Documento',
                        hintText: 'Filtar por Documento',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  )),
              ElevatedButton(
                  child: Text('Filtrar'),
                  onPressed: () {
                    UserModel filtronuevo = new UserModel();
                    filtronuevo.nombre = nombreFiltroController.text == null
                        ? null
                        : nombreFiltroController.text;
                    filtronuevo.apellido = apellidoFiltroController.text == null
                        ? null
                        : apellidoFiltroController.text;
                    filtronuevo.documento =
                        documentoFiltroController.text.isEmpty
                            ? null
                            : BigInt.parse(documentoFiltroController.text);

                    nombreFiltroController.text = null;
                    apellidoFiltroController.text = null;
                    documentoFiltroController.text = null;
                    setState(() {
                      filtro = filtronuevo;
                    });
                    Navigator.pop(context, true);
                  })
            ],
          ),
        ));
  }

  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Filtro"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            content: contentBox(context),
          );
        });
  }
}

buildDataColumns() {
  List columns = <DataColumn>[
    DataColumn(
      label: Text(
        'ID',
      ),
    ),
    DataColumn(
      label: Text(
        'Nombre(s)',
      ),
    ),
    DataColumn(
      label: Text(
        'Apellidos(s)',
      ),
    ),
    DataColumn(
      label: Text(
        'Nacionalidad',
      ),
    ),
    DataColumn(
      label: Text(
        'Tipo Documento',
      ),
    ),
    DataColumn(
      label: Text(
        'Documento',
      ),
    ),
    DataColumn(
      label: Text(
        'Email',
      ),
    ),
    DataColumn(
      label: Text(
        'Telefono',
      ),
    ),
    DataColumn(
      label: Text(
        'Observaciones',
      ),
    ),
    DataColumn(
      label: Text(
        'Fecha',
      ),
    ),
    DataColumn(
      label: Text(
        'Estado',
      ),
    ),
  ];
  return columns;
}
