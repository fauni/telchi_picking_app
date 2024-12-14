// To parse this JSON data, do
//
//     final almacen = almacenFromJson(jsonString);

import 'dart:convert';

Almacen almacenFromJson(String str) => Almacen.fromJson(json.decode(str));

String almacenToJson(Almacen data) => json.encode(data.toJson());

class Almacen {
    final int? id;
    final String? codigo;
    final String? nombre;

    Almacen({
        this.id,
        this.codigo,
        this.nombre,
    });

    Almacen copyWith({
        int? id,
        String? codigo,
        String? nombre,
    }) => 
        Almacen(
            id: id ?? this.id,
            codigo: codigo ?? this.codigo,
            nombre: nombre ?? this.nombre,
        );

    factory Almacen.fromJson(Map<String, dynamic> json) => Almacen(
        id: json["id"],
        codigo: json["codigo"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "codigo": codigo,
        "nombre": nombre,
    };
}
