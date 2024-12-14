
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/repository/conteo_repository.dart';

import '../bloc.dart';

class ConteoBloc extends Bloc<ConteoEvent, ConteoState> {
  final ConteoRepository conteoRepository;

  ConteoBloc(this.conteoRepository) : super(ConteoInitial()) {
    on<ObtenerConteosPorUsuario>(_onObtenerConteosPorUsuario);
  }

  Future<void> _onObtenerConteosPorUsuario(ObtenerConteosPorUsuario event, Emitter<ConteoState> emit) async{
    emit(ConteoCargando());
    try {
      final response = await conteoRepository.obtenerConteosPorUsuario();
      if(response.isSuccessful && response.resultado != null){
        emit(ConteoCargado(response));
      } else {
        emit(ConteoError(response.statusCode, response.errorMessages?.join(', ') ?? 'Error desconocido'));
      }
    } catch (e) {
      emit(const ConteoError(500, "Error al cargar los conteos"));
    }
  }
}
