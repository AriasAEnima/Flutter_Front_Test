import 'dart:convert';

class UserList {
  final List<UserModel> users;
  UserList(this.users);

  UserList.fromJson(List<dynamic> usersJson)
      : users = usersJson.map((user) => UserModel.fromJson(user)).toList();
}

class UserModel {
  BigInt id;
  String nombre;
  String apellido;
  String nacionalidad;
  String tipoDocumento;
  BigInt documento;
  String email;
  String telefono;
  String fecha;
  String observaciones;
  String estado;

  UserModel(
      {this.id,
      this.nombre,
      this.apellido,
      this.nacionalidad,
      this.tipoDocumento,
      this.documento,
      this.email,
      this.observaciones,
      this.telefono,
      this.fecha,
      this.estado});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        nombre: json["nombre"] as String,
        apellido: json["apellido"] as String,
        nacionalidad: json["nacionalidad"] as String,
        tipoDocumento: json["tipoDocumento"] as String,
        documento: json["documento"],
        email: json["email"] as String,
        telefono: json["telefono"] as String,
        observaciones: json["observaciones"] as String,
        fecha: json["fecha"] as String,
        estado: json["estado"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "apellido": apellido,
        "nacionalidad": nacionalidad,
        "tipoDocumento": tipoDocumento,
        "documento": documento,
        "email": email,
        "telefono": telefono,
        "observaciones": observaciones,
        "fecha": fecha,
        "estado": estado,
      };
}
