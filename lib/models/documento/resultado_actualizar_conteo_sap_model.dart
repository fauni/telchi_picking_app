class ResultadoGenericoMensaje {
  final String message;

  ResultadoGenericoMensaje({required this.message});

  factory ResultadoGenericoMensaje.fromJson(Map<String, dynamic> json) {
    return ResultadoGenericoMensaje(
      message: json['message'],
    );
  }
}