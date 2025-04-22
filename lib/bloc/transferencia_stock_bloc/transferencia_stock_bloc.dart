
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/transferencia_stock_repository.dart';

class TransferenciaStockBloc extends Bloc<TransferenciaStockEvent, TransferenciaStockState>{
  final TransferenciaStockRepository repository;

  TransferenciaStockBloc(this.repository) : super(TransferenciaStockInitial()){
    on<LoadTransferenciaStock>(_onLoadTransferenciaStock);
  }

  Future<void> _onLoadTransferenciaStock(LoadTransferenciaStock event, Emitter<TransferenciaStockState> emit) async {
    emit(TransferenciaStockLoading());
    try {
      final transferencias = await repository.obtenerTransferenciasStock(
        event.pageNumber, 
        event.pageSize,
        search: event.search,
        docDate: event.docDate
      );
      emit(TransferenciasStockLoaded(solicitudesTraslado: transferencias.resultado!));
    } catch (e) {
      emit(TransferenciaStockLoadError(message: e.toString()));
    }
  }
}