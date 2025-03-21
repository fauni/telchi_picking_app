
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/solicitud_traslado_repository.dart';

class SolicitudTrasladoBloc extends Bloc<SolicitudTrasladoEvent, SolicitudTrasladoState>{
  final SolicitudTrasladoRepository repository;

  SolicitudTrasladoBloc(this.repository) : super(SolicitudTrasladoInitial()){
    on<LoadSolicitudesTraslado>(_onLoadSolicitudesTraslado);
  }

  Future<void> _onLoadSolicitudesTraslado(LoadSolicitudesTraslado event, Emitter<SolicitudTrasladoState> emit) async {
    emit(SolicitudTrasladoLoading());
    try {
      final solicitudesTraslado = await repository.obtenerSolicitudesTraslado(
        event.pageNumber, 
        event.pageSize,
        search: event.search,
        docDate: event.docDate
      );
      emit(SolicitudesTrasladoLoaded(solicitudesTraslado: solicitudesTraslado.resultado!));
    } catch (e) {
      emit(SolicitudTrasladoLoadError(message: e.toString()));
    }
  }
}