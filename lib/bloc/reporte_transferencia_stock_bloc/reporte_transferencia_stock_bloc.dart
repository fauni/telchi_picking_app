
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/reporte_transferecia_stock_repository.dart';

class ReporteTransferenciaStockBloc extends Bloc<ReporteTransferenciaStockEvent, ReporteTransferenciaStockState> {
  final ReporteTransfereciaStockRepository reporteRepository;

  ReporteTransferenciaStockBloc({required this.reporteRepository}) : super(ReporteTransferenciaStockInitial()) {
    on<DownloadReportTransferenciaStockEvent>(_onDownloadReport);
  }

  Future<void> _onDownloadReport(
      DownloadReportTransferenciaStockEvent event, 
      Emitter<ReporteTransferenciaStockState> emit
  ) async {
    emit(ReporteTransferenciaStockLoading());
    try {
      final filePath = await reporteRepository.downloadReport(
        tipoDocumento: event.tipoDocumento,
        docEntry: event.docEntry,
      );
      emit(ReporteTransferenciaStockDownloadSuccess(filePath: filePath));
    } catch (error) {
      emit(ReporteTransferenciaStockDownloadFailure(error: error.toString()));
    }
  }
}