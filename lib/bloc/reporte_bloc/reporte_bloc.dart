
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/reporte_repository.dart';

class ReporteBloc extends Bloc<ReporteEvent, ReporteState> {
  final ReporteRepository reporteRepository;

  ReporteBloc({required this.reporteRepository}) : super(ReporteInitial()) {
    on<DownloadReportEvent>(_onDownloadReport);
  }

  Future<void> _onDownloadReport(
      DownloadReportEvent event, 
      Emitter<ReporteState> emit
  ) async {
    emit(ReporteLoading());
    try {
      final filePath = await reporteRepository.downloadReport(
        tipoDocumento: event.tipoDocumento,
        docNum: event.docNum,
      );
      emit(ReporteDownloadSuccess(filePath: filePath));
    } catch (error) {
      emit(ReporteDownloadFailure(error: error.toString()));
    }
  }
}