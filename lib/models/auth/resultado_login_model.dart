import 'package:picking_app/models/auth/usuario_model.dart';

class ResultadoLogin {
  final String? token;
  final Usuario? usuario;
  final String? sapSessionId;
  final int? sapSessionTimeout;
  
  ResultadoLogin({
      this.token,
      this.usuario,
      this.sapSessionId,
      this.sapSessionTimeout,
  });

  ResultadoLogin copyWith({
    String? token,
    Usuario? usuario,
    String? sapSessionId,
    int? sapSessionTimeout,
  }) => 
  ResultadoLogin(
    token: token ?? this.token,
    usuario: usuario ?? this.usuario,
    sapSessionId: sapSessionId ?? this.sapSessionId,
    sapSessionTimeout: sapSessionTimeout ?? this.sapSessionTimeout,
  );

  factory ResultadoLogin.fromJson(Map<String, dynamic> json) => ResultadoLogin(
    token: json["token"],
    usuario: json["usuario"] == null ? null : Usuario.fromJson(json["usuario"]),
    sapSessionId: json["sapSessionId"],
    sapSessionTimeout: json["sapSessionTimeout"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "usuario": usuario?.toJson(),
    "sapSessionId": sapSessionId,
    "sapSessionTimeout": sapSessionTimeout,
  };
}