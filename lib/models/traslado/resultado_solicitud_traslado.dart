
import 'package:picking_app/models/picking/documento_model.dart';

class SolicitudTraslado {
  final int? docEntry;
  final int? docNum;
  final int? series;
  final DateTime? docDate;
  final DateTime? docDueDate;
  final String? comments;
  final String? jrnlMemo;
  final String? filler;
  final String? toWhsCode;
  final String? docStatus;
  final Documento? documento;
  final List<LineSolicitudTraslado>? lines;

  SolicitudTraslado({
    this.docEntry,
    this.docNum,
    this.series,
    this.docDate,
    this.docDueDate,
    this.comments,
    this.jrnlMemo,
    this.filler,
    this.toWhsCode,
    this.docStatus,
    this.documento,
    this.lines,
  });

  SolicitudTraslado copyWith({
    int? docEntry,
    int? docNum,
    int? series,
    DateTime? docDate,
    DateTime? docDueDate,
    String? comments,
    String? jrnlMemo,
    String? filler,
    String? toWhsCode,
    String? docStatus,
    Documento? documento,
    List<LineSolicitudTraslado>? lines,
  }) =>
    SolicitudTraslado(
      docEntry: docEntry ?? this.docEntry,
      docNum: docNum ?? this.docNum,
      series: series ?? this.series,
      docDate: docDate ?? this.docDate,
      docDueDate: docDueDate ?? this.docDueDate,
      comments: comments ?? this.comments,
      jrnlMemo: jrnlMemo ?? this.jrnlMemo,
      filler: filler ?? this.filler,
      toWhsCode: toWhsCode ?? this.toWhsCode,
      docStatus: docStatus ?? this.docStatus,
      documento: documento ?? this.documento,
      lines: lines ?? this.lines,
    );

  factory SolicitudTraslado.fromJson(Map<String, dynamic> json) => SolicitudTraslado(
    docEntry: json["docEntry"],
    docNum: json["docNum"],
    series: json["series"],
    docDate: json["docDate"] == null ? null : DateTime.parse(json["docDate"]),
    docDueDate: json["docDueDate"] == null ? null : DateTime.parse(json["docDueDate"]),
    comments: json["comments"],
    jrnlMemo: json["jrnlMemo"],
    filler: json["filler"],
    toWhsCode: json["toWhsCode"],
    docStatus: json["docStatus"],
    documento: json["documento"] == null ? null : Documento.fromJson(json["documento"]),
    lines: List<LineSolicitudTraslado>.from(json["lines"].map((x) => LineSolicitudTraslado.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "docEntry": docEntry,
    "docNum": docNum,
    "series": series,
    "docDate": docDate?.toIso8601String(),
    "docDueDate": docDueDate?.toIso8601String(),
    "comments": comments,
    "jrnlMemo": jrnlMemo,
    "filler": filler,
    "toWhsCode": toWhsCode,
    "docStatus": docStatus,
    "documento": documento!.toJson(),
    "lines": List<dynamic>.from(lines!.map((x) => x.toJson())),
  };
}

class LineSolicitudTraslado {
  final int? docEntry;
  final int? lineNum;
  final String? lineStatus;
  final String? itemCode;
  final String? dscription;
  final String? codeBars;
  final double? quantity;
  final String? fromWhsCod;
  final String? whsCode;
  final double? uPckCantContada;
  final String? uPckContUsuarios;
  final DetalleDocumento? detalleDocumento;

  LineSolicitudTraslado({
    this.docEntry,
    this.lineNum,
    this.lineStatus,
    this.itemCode,
    this.dscription,
    this.codeBars,
    this.quantity,
    this.fromWhsCod,
    this.whsCode,
    this.uPckCantContada,
    this.uPckContUsuarios,
    this.detalleDocumento,
  });

  LineSolicitudTraslado copyWith({
    int? docEntry,
    int? lineNum,
    String? lineStatus,
    String? itemCode,
    String? dscription,
    String? codeBars,
    double? quantity,
    String? fromWhsCod,
    String? whsCode,
    double? uPckCantContada,
    String? uPckContUsuarios,
    DetalleDocumento? detalleDocumento
  }) =>
    LineSolicitudTraslado(
      docEntry: docEntry ?? this.docEntry,
      lineNum: lineNum ?? this.lineNum,
      lineStatus: lineStatus ?? this.lineStatus,
      itemCode: itemCode ?? this.itemCode,
      dscription: dscription ?? this.dscription,
      codeBars: codeBars ?? this.codeBars,
      quantity: quantity ?? this.quantity,
      fromWhsCod: fromWhsCod ?? this.fromWhsCod,
      whsCode: whsCode ?? this.whsCode,
      uPckCantContada: uPckCantContada ?? this.uPckCantContada,
      uPckContUsuarios: uPckContUsuarios ?? this.uPckContUsuarios,
      detalleDocumento: detalleDocumento ?? this.detalleDocumento
    );    

  factory LineSolicitudTraslado.fromJson(Map<String, dynamic> json) => LineSolicitudTraslado(
    docEntry: json["docEntry"],
    lineNum: json["lineNum"],
    lineStatus: json["lineStatus"],
    itemCode: json["itemCode"],
    dscription: json["dscription"],
    codeBars: json["codeBars"],
    quantity: json["quantity"]?.toDouble(),
    fromWhsCod: json["fromWhsCod"],
    whsCode: json["whsCode"],
    uPckCantContada: json["u_PCK_CantContada"]?.toDouble(),
    uPckContUsuarios: json["u_PCK_ContUsuarios"],
    detalleDocumento: json["detalleDocumento"] == null ? null : DetalleDocumento.fromJson(json["detalleDocumento"]),
  );

  Map<String, dynamic> toJson() => {
    "docEntry": docEntry,
    "lineNum": lineNum,
    "lineStatus": lineStatus,
    "itemCode": itemCode,
    "dscription": dscription,
    "codeBars": codeBars,
    "quantity": quantity,
    "fromWhsCod": fromWhsCod,
    "whsCode": whsCode,
    "u_PCK_CantContada": uPckCantContada,
    "u_PCK_ContUsuarios": uPckContUsuarios,
    "detalleDocumento": detalleDocumento!.toJson(),
  };
}