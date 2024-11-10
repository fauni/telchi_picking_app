class ApiResponseList<T> {
  final int statusCode;
  final bool isSuccessful;
  final List<String>? errorMessages;
  final List<T>? resultado;

  ApiResponseList({
    required this.statusCode,
    required this.isSuccessful,
    this.errorMessages,
    this.resultado,
  });

  // Método factory para construir ApiResponseList desde JSON para una lista de objetos
  factory ApiResponseList.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) createResultado,
  ) {
    return ApiResponseList<T>(
      statusCode: json["statusCode"],
      isSuccessful: json["isSuccessful"],
      errorMessages: json["errorMessages"] != null
          ? List<String>.from(json['errorMessages'])
          : null,
      resultado: json["resultado"] != null
          ? (json["resultado"] as List)
              .map((item) => createResultado(item))
              .toList()
          : null,
    );
  }
}
