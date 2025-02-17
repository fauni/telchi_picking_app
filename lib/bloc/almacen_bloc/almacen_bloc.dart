import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/almacen_bloc/almacen_event.dart';
import 'package:picking_app/bloc/almacen_bloc/almacen_state.dart';
import 'package:picking_app/repository/auth_repository.dart';

class AlmacenBloc extends Bloc<AlmacenEvent, AlmacenState>{
  final AuthRepository authRepository;

  AlmacenBloc(this.authRepository) : super(AlmacenInitial()){
    on<LoadAlmacenesForUser>(_onLoadAlmacenesPorUsuario);
  }

  Future<void> _onLoadAlmacenesPorUsuario(LoadAlmacenesForUser event, Emitter<AlmacenState> emit) async {
    emit(AlmacenLoading());
    try {
      final almacenes = await authRepository.getAlmacenesUsuario();
      emit(AlmacenesLoaded(almacenes: almacenes));
    } catch (e) {
      emit(AlmacenError(message: e.toString()));
    }
  }
}