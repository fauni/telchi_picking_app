// To parse this JSON data, do
//
//     final conteoRequest = conteoRequestFromJson(jsonString);

import 'dart:convert';

ConteoRequest conteoRequestFromJson(String str) => ConteoRequest.fromJson(json.decode(str));

String conteoRequestToJson(ConteoRequest data) => json.encode(data.toJson());

class ConteoRequest {
    String? nombreUsuario;
    String? codigoAlmacen;
    String? comentarios;
    String? estado;

    ConteoRequest({
        this.nombreUsuario,
        this.codigoAlmacen,
        this.comentarios,
        this.estado,
    });

    ConteoRequest copyWith({
        String? nombreUsuario,
        String? codigoAlmacen,
        String? comentarios,
        String? estado,
    }) => 
        ConteoRequest(
            nombreUsuario: nombreUsuario ?? this.nombreUsuario,
            codigoAlmacen: codigoAlmacen ?? this.codigoAlmacen,
            comentarios: comentarios ?? this.comentarios,
            estado: estado ?? this.estado,
        );

    factory ConteoRequest.fromJson(Map<String, dynamic> json) => ConteoRequest(
        nombreUsuario: json["NombreUsuario"],
        codigoAlmacen: json["CodigoAlmacen"],
        comentarios: json["Comentarios"],
        estado: json["Estado"],
    );

    Map<String, dynamic> toJson() => {
        "NombreUsuario": nombreUsuario,
        "CodigoAlmacen": codigoAlmacen,
        "Comentarios": comentarios,
        "Estado": estado,
    };
}
