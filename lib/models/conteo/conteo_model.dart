// To parse this JSON data, do
//
//     final conteo = conteoFromJson(jsonString);

import 'dart:convert';

Conteo conteoFromJson(String str) => Conteo.fromJson(json.decode(str));

String conteoToJson(Conteo data) => json.encode(data.toJson());

class Conteo {
    final int? id;
    final String? nombreUsuario;
    final String? codigoAlmacen;
    final String? comentarios;
    final DateTime? fechaInicio;
    final dynamic fechaFinalizacion;
    final String? estado;

    Conteo({
        this.id,
        this.nombreUsuario,
        this.codigoAlmacen,
        this.comentarios,
        this.fechaInicio,
        this.fechaFinalizacion,
        this.estado,
    });

    Conteo copyWith({
        int? id,
        String? nombreUsuario,
        String? codigoAlmacen,
        String? comentarios,
        DateTime? fechaInicio,
        dynamic fechaFinalizacion,
        String? estado,
    }) => 
        Conteo(
            id: id ?? this.id,
            nombreUsuario: nombreUsuario ?? this.nombreUsuario,
            codigoAlmacen: codigoAlmacen ?? this.codigoAlmacen,
            comentarios: comentarios ?? this.comentarios,
            fechaInicio: fechaInicio ?? this.fechaInicio,
            fechaFinalizacion: fechaFinalizacion ?? this.fechaFinalizacion,
            estado: estado ?? this.estado,
        );

    factory Conteo.fromJson(Map<String, dynamic> json) => Conteo(
        id: json["id"],
        nombreUsuario: json["nombreUsuario"],
        codigoAlmacen: json["codigoAlmacen"],
        comentarios: json["comentarios"],
        fechaInicio: json["fechaInicio"] == null ? null : DateTime.parse(json["fechaInicio"]),
        fechaFinalizacion: json["fechaFinalizacion"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombreUsuario": nombreUsuario,
        "codigoAlmacen": codigoAlmacen,
        "comentarios": comentarios,
        "fechaInicio": fechaInicio?.toIso8601String(),
        "fechaFinalizacion": fechaFinalizacion,
        "estado": estado,
    };
}
