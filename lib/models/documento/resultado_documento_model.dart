class ResultadoDocumentoModel {
  final int documentId;

  ResultadoDocumentoModel({required this.documentId});

  factory ResultadoDocumentoModel.fromJson(Map<String, dynamic> json) {
    return ResultadoDocumentoModel(
      documentId: json['documentId'],
    );
  }
}

