import 'package:picking_app/models/almacen/almacen_model.dart';

class Usuario {
  final int? id;
  final String? apellidoPaterno;
  final String? apellidoMaterno;
  final String? nombres;
  final String? usuarioNombre;
  final String? email;
  final dynamic passwordHash;
  final dynamic passwordSalt;
  final bool? estaBloqueado;
  final bool? estaActivo;
  final DateTime? fechaCreacion;
  final dynamic fechaModificacion;
  final List<Almacen>? almacenes;

  Usuario({
      this.id,
      this.apellidoPaterno,
      this.apellidoMaterno,
      this.nombres,
      this.usuarioNombre,
      this.email,
      this.passwordHash,
      this.passwordSalt,
      this.estaBloqueado,
      this.estaActivo,
      this.fechaCreacion,
      this.fechaModificacion,
      this.almacenes
  });

  Usuario copyWith({
      int? id,
      String? apellidoPaterno,
      String? apellidoMaterno,
      String? nombres,
      String? usuarioNombre,
      String? email,
      dynamic passwordHash,
      dynamic passwordSalt,
      bool? estaBloqueado,
      bool? estaActivo,
      DateTime? fechaCreacion,
      dynamic fechaModificacion,
      List<Almacen>? almacenes
  }) => 
      Usuario(
          id: id ?? this.id,
          apellidoPaterno: apellidoPaterno ?? this.apellidoPaterno,
          apellidoMaterno: apellidoMaterno ?? this.apellidoMaterno,
          nombres: nombres ?? this.nombres,
          usuarioNombre: usuarioNombre ?? this.usuarioNombre,
          email: email ?? this.email,
          passwordHash: passwordHash ?? this.passwordHash,
          passwordSalt: passwordSalt ?? this.passwordSalt,
          estaBloqueado: estaBloqueado ?? this.estaBloqueado,
          estaActivo: estaActivo ?? this.estaActivo,
          fechaCreacion: fechaCreacion ?? this.fechaCreacion,
          fechaModificacion: fechaModificacion ?? this.fechaModificacion,
          almacenes: almacenes ?? this.almacenes
      );

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
      id: json["id"],
      apellidoPaterno: json["apellidoPaterno"],
      apellidoMaterno: json["apellidoMaterno"],
      nombres: json["nombres"],
      usuarioNombre: json["usuarioNombre"],
      email: json["email"],
      passwordHash: json["passwordHash"],
      passwordSalt: json["passwordSalt"],
      estaBloqueado: json["estaBloqueado"],
      estaActivo: json["estaActivo"],
      fechaCreacion: json["fechaCreacion"] == null ? null : DateTime.parse(json["fechaCreacion"]),
      fechaModificacion: json["fechaModificacion"],
      almacenes: json["almacenes"] == null ? [] : List<Almacen>.from(json["almacenes"]!.map((x) => Almacen.fromJson(x)))
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "apellidoPaterno": apellidoPaterno,
    "apellidoMaterno": apellidoMaterno,
    "nombres": nombres,
    "usuarioNombre": usuarioNombre,
    "email": email,
    "passwordHash": passwordHash,
    "passwordSalt": passwordSalt,
    "estaBloqueado": estaBloqueado,
    "estaActivo": estaActivo,
    "fechaCreacion": fechaCreacion?.toIso8601String(),
    "fechaModificacion": fechaModificacion,
    "almacenes": almacenes == null ? [] : List<dynamic>.from(almacenes!.map((x) => x.toJson()))
  };
}