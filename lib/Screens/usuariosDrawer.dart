import 'package:flutter/material.dart';
import 'package:smartjsp_prueba_front/Screens/obtenerUsuarios.dart';
import 'package:smartjsp_prueba_front/Screens/registrarUsuario.dart';

class UsuariosDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UsuariosDrawerState();
  }
}

class UsuariosDrawerState extends State<UsuariosDrawer> {
  final minimoPadding = 5.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Manejo de Usuarios'),
        ),
        body: Center(
            child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Column(
            children: [
              Text(
                "Bienvenido a Administracion de Usuarios",
                style: TextStyle(fontSize: 50.0),
              ),
              Text(
                "Selecione una opcion del Menú (Esquina superior Derecha)",
                style: TextStyle(fontSize: 30.0),
              ),
              Icon(
                Icons.switch_account,
                size: 300,
              ),
              Text(
                "Realizado por: Julian Eduardo Arias Barrera",
                style: TextStyle(fontSize: 30.0),
              )
            ],
          ),
        )),
        drawer: Drawer(
          child: ListView(
              padding: EdgeInsets.only(bottom: minimoPadding),
              children: <Widget>[
                DrawerHeader(
                  child: Text("Manejo de usuarios",
                      style: TextStyle(fontSize: 24)),
                  decoration: BoxDecoration(color: Colors.orange),
                ),
                ListTile(
                  title: Text("Ver Usuario Activos / Modificar"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ObtenerUsuarios()));
                  },
                ),
                ListTile(
                  title: Text("Registrar Usuario"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrarUsuario()));
                  },
                ),
              ]),
        ));
  }
}
