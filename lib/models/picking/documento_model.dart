class Documento {
    final int? idDocumento;
    final String? tipoDocumento;
    final String? numeroDocumento;
    final DateTime? fechaInicio;
    final DateTime? fechaFinalizacion;
    final String? estadoConteo;
    final List<DetalleDocumento>? detalles;

    Documento({
        this.idDocumento,
        this.tipoDocumento,
        this.numeroDocumento,
        this.fechaInicio,
        this.fechaFinalizacion,
        this.estadoConteo,
        this.detalles,
    });

    Documento copyWith({
        int? idDocumento,
        String? tipoDocumento,
        String? numeroDocumento,
        DateTime? fechaInicio,
        DateTime? fechaFinalizacion,
        String? estadoConteo,
        List<DetalleDocumento>? detalles,
    }) => 
        Documento(
            idDocumento: idDocumento ?? this.idDocumento,
            tipoDocumento: tipoDocumento ?? this.tipoDocumento,
            numeroDocumento: numeroDocumento ?? this.numeroDocumento,
            fechaInicio: fechaInicio ?? this.fechaInicio,
            fechaFinalizacion: fechaFinalizacion ?? this.fechaFinalizacion,
            estadoConteo: estadoConteo ?? this.estadoConteo,
            detalles: detalles ?? this.detalles,
        );

    factory Documento.fromJson(Map<String, dynamic> json) => Documento(
        idDocumento: json["idDocumento"],
        tipoDocumento: json["tipoDocumento"],
        numeroDocumento: json["numeroDocumento"],
        fechaInicio: json["fechaInicio"] == null ? null : DateTime.parse(json["fechaInicio"]),
        fechaFinalizacion: json["fechaFinalizacion"] == null ? null : DateTime.parse(json["fechaFinalizacion"]),
        estadoConteo: json["estadoConteo"],
        detalles: json["detalles"] == null ? [] : List<DetalleDocumento>.from(json["detalles"]!.map((x) => DetalleDocumento.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "idDocumento": idDocumento,
        "tipoDocumento": tipoDocumento,
        "numeroDocumento": numeroDocumento,
        "fechaInicio": fechaInicio?.toIso8601String(),
        "fechaFinalizacion": fechaFinalizacion?.toIso8601String(),
        "estadoConteo": estadoConteo,
        "detalles": detalles == null ? [] : List<dynamic>.from(detalles!.map((x) => x.toJson())),
    };
}

class DetalleDocumento {
    final int? idDetalle;
    final int? idDocumento;
    final int? numeroLinea;
    final String? codigoItem;
    final String? descripcionItem;
    final double? cantidadEsperada;
    final double? cantidadContada;
    final String? estado;
    final List<dynamic>? conteos;

    DetalleDocumento({
        this.idDetalle,
        this.idDocumento,
        this.numeroLinea,
        this.codigoItem,
        this.descripcionItem,
        this.cantidadEsperada,
        this.cantidadContada,
        this.estado,
        this.conteos,
    });

    DetalleDocumento copyWith({
        int? idDetalle,
        int? idDocumento,
        int? numeroLinea,
        String? codigoItem,
        String? descripcionItem,
        double? cantidadEsperada,
        double? cantidadContada,
        String? estado,
        List<dynamic>? conteos,
    }) => 
        DetalleDocumento(
            idDetalle: idDetalle ?? this.idDetalle,
            idDocumento: idDocumento ?? this.idDocumento,
            numeroLinea: numeroLinea ?? this.numeroLinea,
            codigoItem: codigoItem ?? this.codigoItem,
            descripcionItem: descripcionItem ?? this.descripcionItem,
            cantidadEsperada: cantidadEsperada ?? this.cantidadEsperada,
            cantidadContada: cantidadContada ?? this.cantidadContada,
            estado: estado ?? this.estado,
            conteos: conteos ?? this.conteos,
        );

    factory DetalleDocumento.fromJson(Map<String, dynamic> json) => DetalleDocumento(
        idDetalle: json["idDetalle"],
        idDocumento: json["idDocumento"],
        numeroLinea: json["numeroLinea"],
        codigoItem: json["codigoItem"],
        descripcionItem: json["descripcionItem"],
        cantidadEsperada: json["cantidadEsperada"],
        cantidadContada: json["cantidadContada"],
        estado: json["estado"],
        conteos: json["conteos"] == null ? [] : List<dynamic>.from(json["conteos"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "idDetalle": idDetalle,
        "idDocumento": idDocumento,
        "numeroLinea": numeroLinea,
        "codigoItem": codigoItem,
        "descripcionItem": descripcionItem,
        "cantidadEsperada": cantidadEsperada,
        "cantidadContada": cantidadContada,
        "estado": estado,
        "conteos": conteos == null ? [] : List<dynamic>.from(conteos!.map((x) => x)),
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}