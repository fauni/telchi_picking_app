// To parse this JSON data, do
//
//     final detalleConteo = detalleConteoFromJson(jsonString);

import 'dart:convert';

DetalleConteo detalleConteoFromJson(String str) => DetalleConteo.fromJson(json.decode(str));

String detalleConteoToJson(DetalleConteo data) => json.encode(data.toJson());

class DetalleConteo {
    final int? id;
    final int? conteoId;
    final String? codigoItem;
    final String? codigoBarras;
    final String? codigoAlmacen;
    final String? descripcionItem;
    final double? cantidadDisponible;
    final double? cantidadComprometida;
    final double? cantidadPendienteDeRecibir;
    final double? cantidadContada;
    final String? estado;

    DetalleConteo({
        this.id,
        this.conteoId,
        this.codigoItem,
        this.codigoBarras,
        this.codigoAlmacen,
        this.descripcionItem,
        this.cantidadDisponible,
        this.cantidadComprometida,
        this.cantidadPendienteDeRecibir,
        this.cantidadContada,
        this.estado,
    });

    DetalleConteo copyWith({
        int? id,
        int? conteoId,
        String? codigoItem,
        String? codigoBarras,
        String? codigoAlmacen,
        String? descripcionItem,
        double? cantidadDisponible,
        double? cantidadComprometida,
        double? cantidadPendienteDeRecibir,
        double? cantidadContada,
        String? estado,
    }) => 
        DetalleConteo(
            id: id ?? this.id,
            conteoId: conteoId ?? this.conteoId,
            codigoItem: codigoItem ?? this.codigoItem,
            codigoBarras: codigoBarras ?? this.codigoBarras,
            codigoAlmacen: codigoAlmacen ?? this.codigoAlmacen,
            descripcionItem: descripcionItem ?? this.descripcionItem,
            cantidadDisponible: cantidadDisponible ?? this.cantidadDisponible,
            cantidadComprometida: cantidadComprometida ?? this.cantidadComprometida,
            cantidadPendienteDeRecibir: cantidadPendienteDeRecibir ?? this.cantidadPendienteDeRecibir,
            cantidadContada: cantidadContada ?? this.cantidadContada,
            estado: estado ?? this.estado,
        );

    factory DetalleConteo.fromJson(Map<String, dynamic> json) => DetalleConteo(
        id: json["id"],
        conteoId: json["conteoId"],
        codigoItem: json["codigoItem"],
        codigoBarras: json["codigoBarras"],
        codigoAlmacen: json["codigoAlmacen"],
        descripcionItem: json["descripcionItem"],
        cantidadDisponible: json["cantidadDisponible"],
        cantidadComprometida: json["cantidadComprometida"],
        cantidadPendienteDeRecibir: json["cantidadPendienteDeRecibir"],
        cantidadContada: json["cantidadContada"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "conteoId": conteoId,
        "codigoItem": codigoItem,
        "codigoBarras": codigoBarras,
        "codigoAlmacen": codigoAlmacen,
        "descripcionItem": descripcionItem,
        "cantidadDisponible": cantidadDisponible,
        "cantidadComprometida": cantidadComprometida,
        "cantidadPendienteDeRecibir": cantidadPendienteDeRecibir,
        "cantidadContada": cantidadContada,
        "estado": estado,
    };
}
