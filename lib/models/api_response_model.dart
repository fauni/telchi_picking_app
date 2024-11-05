class ApiResponse<T> {
  final int statusCode;
  final bool isSuccessful;
  final List<String>? errorMessages;
  final T? resultado;

  ApiResponse({
    required this.statusCode,
    required this.isSuccessful,
    this.errorMessages,
    this.resultado
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) createResultado) {
    return ApiResponse<T>(
      statusCode: json["statusCode"],
      isSuccessful: json["isSuccessful"],
      errorMessages: json["errorMessages"] != null ? List<String>.from(json['errorMessages']) : null,
      resultado: json["resultado"] == null ? null : createResultado(json["resultado"]),
    );
  } 

  // Map<String, dynamic> toJson() => {
  //   "statusCode": statusCode,
  //   "isSuccessful": isSuccessful,
  //   "errorMessages": errorMessages,
  //   "resultado": resultado?.toJson(),
  // };

}