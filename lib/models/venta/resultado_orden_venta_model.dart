import 'package:picking_app/models/picking/documento_model.dart';

class ResultadoOrdenVentaModel {
    final int? docEntry;
    final int? docNum;
    final String? docType;
    final DateTime? docDate;
    final DateTime? docDueDate;
    final String? cardCode;
    final String? cardName;
    final double? docTotal;
    final String? docCurrency;
    final String? comments;
    final String? documentStatus;
    final Documento? documento;
    final List<DocumentLineOrdenVenta>? documentLines;

    ResultadoOrdenVentaModel({
        this.docEntry,
        this.docNum,
        this.docType,
        this.docDate,
        this.docDueDate,
        this.cardCode,
        this.cardName,
        this.docTotal,
        this.docCurrency,
        this.comments,
        this.documentStatus,
        this.documento,
        this.documentLines,
    });

    ResultadoOrdenVentaModel copyWith({
        int? docEntry,
        int? docNum,
        String? docType,
        DateTime? docDate,
        DateTime? docDueDate,
        String? cardCode,
        String? cardName,
        double? docTotal,
        String? docCurrency,
        String? comments,
        String? documentStatus,
        Documento? documento,
        List<DocumentLineOrdenVenta>? documentLines,
    }) => 
        ResultadoOrdenVentaModel(
            docEntry: docEntry ?? this.docEntry,
            docNum: docNum ?? this.docNum,
            docType: docType ?? this.docType,
            docDate: docDate ?? this.docDate,
            docDueDate: docDueDate ?? this.docDueDate,
            cardCode: cardCode ?? this.cardCode,
            cardName: cardName ?? this.cardName,
            docTotal: docTotal ?? this.docTotal,
            docCurrency: docCurrency ?? this.docCurrency,
            comments: comments ?? this.comments,
            documentStatus: documentStatus ?? this.documentStatus,
            documento: documento ?? this.documento,
            documentLines: documentLines ?? this.documentLines,
        );

    factory ResultadoOrdenVentaModel.fromJson(Map<String, dynamic> json) => ResultadoOrdenVentaModel(
        docEntry: json["docEntry"],
        docNum: json["docNum"],
        docType: json["docType"],
        docDate: json["docDate"] == null ? null : DateTime.parse(json["docDate"]),
        docDueDate: json["docDueDate"] == null ? null : DateTime.parse(json["docDueDate"]),
        cardCode: json["cardCode"],
        cardName: json["cardName"],
        docTotal: json["docTotal"]?.toDouble(),
        docCurrency: json["docCurrency"],
        comments: json["comments"],
        documentStatus: json["documentStatus"],
        documento: json["documento"] == null ? null : Documento.fromJson(json["documento"]),
        documentLines: json["documentLines"] == null ? [] : List<DocumentLineOrdenVenta>.from(json["documentLines"]!.map((x) => DocumentLineOrdenVenta.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "docEntry": docEntry,
        "docNum": docNum,
        "docType": docType,
        "docDate": docDate?.toIso8601String(),
        "docDueDate": docDueDate?.toIso8601String(),
        "cardCode": cardCode,
        "cardName": cardName,
        "docTotal": docTotal,
        "docCurrency": docCurrency,
        "comments": comments,
        "documentStatus": documentStatus,
        "documento": documento?.toJson(),
        "documentLines": documentLines == null ? [] : List<dynamic>.from(documentLines!.map((x) => x.toJson())),
    };
}

class DocumentLineOrdenVenta {
    final int? lineNum;
    final String? itemCode;
    final String? itemDescription;
    final int? quantity;
    final double? price;
    final double? priceAfterVat;
    final String? currency;
    final String? barCode;
    final List<LineTaxJurisdiction>? lineTaxJurisdictions;

    DocumentLineOrdenVenta({
        this.lineNum,
        this.itemCode,
        this.itemDescription,
        this.quantity,
        this.price,
        this.priceAfterVat,
        this.currency,
        this.barCode,
        this.lineTaxJurisdictions,
    });

    DocumentLineOrdenVenta copyWith({
        int? lineNum,
        String? itemCode,
        String? itemDescription,
        int? quantity,
        double? price,
        double? priceAfterVat,
        String? currency,
        String? barCode,
        List<LineTaxJurisdiction>? lineTaxJurisdictions,
    }) => 
        DocumentLineOrdenVenta(
            lineNum: lineNum ?? this.lineNum,
            itemCode: itemCode ?? this.itemCode,
            itemDescription: itemDescription ?? this.itemDescription,
            quantity: quantity ?? this.quantity,
            price: price ?? this.price,
            priceAfterVat: priceAfterVat ?? this.priceAfterVat,
            currency: currency ?? this.currency,
            barCode: barCode ?? this.barCode,
            lineTaxJurisdictions: lineTaxJurisdictions ?? this.lineTaxJurisdictions,
        );

    factory DocumentLineOrdenVenta.fromJson(Map<String, dynamic> json) => DocumentLineOrdenVenta(
        lineNum: json["lineNum"],
        itemCode: json["itemCode"],
        itemDescription: json["itemDescription"],
        quantity: json["quantity"],
        price: json["price"]?.toDouble(),
        priceAfterVat: json["priceAfterVat"]?.toDouble(),
        currency: json["currency"],
        barCode: json["barCode"],
        lineTaxJurisdictions: json["lineTaxJurisdictions"] == null ? [] : List<LineTaxJurisdiction>.from(json["lineTaxJurisdictions"]!.map((x) => LineTaxJurisdiction.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "lineNum": lineNum,
        "itemCode": itemCode,
        "itemDescription": itemDescription,
        "quantity": quantity,
        "price": price,
        "priceAfterVat": priceAfterVat,
        "currency": currency,
        "barCode": barCode,
        "lineTaxJurisdictions": lineTaxJurisdictions == null ? [] : List<dynamic>.from(lineTaxJurisdictions!.map((x) => x.toJson())),
    };
}

class LineTaxJurisdiction {
    final String? jurisdictionCode;
    final double? taxAmount;
    final int? taxRate;

    LineTaxJurisdiction({
        this.jurisdictionCode,
        this.taxAmount,
        this.taxRate,
    });

    LineTaxJurisdiction copyWith({
        String? jurisdictionCode,
        double? taxAmount,
        int? taxRate,
    }) => 
        LineTaxJurisdiction(
            jurisdictionCode: jurisdictionCode ?? this.jurisdictionCode,
            taxAmount: taxAmount ?? this.taxAmount,
            taxRate: taxRate ?? this.taxRate,
        );

    factory LineTaxJurisdiction.fromJson(Map<String, dynamic> json) => LineTaxJurisdiction(
        jurisdictionCode: json["jurisdictionCode"],
        taxAmount: json["taxAmount"]?.toDouble(),
        taxRate: json["taxRate"],
    );

    Map<String, dynamic> toJson() => {
        "jurisdictionCode": jurisdictionCode,
        "taxAmount": taxAmount,
        "taxRate": taxRate,
    };
}