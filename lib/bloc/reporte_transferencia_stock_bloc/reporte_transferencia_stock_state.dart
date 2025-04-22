abstract class ReporteTransferenciaStockState{}

class ReporteTransferenciaStockInitial extends ReporteTransferenciaStockState {}
class ReporteTransferenciaStockLoading extends ReporteTransferenciaStockState {}
class ReporteTransferenciaStockDownloadSuccess extends ReporteTransferenciaStockState {
  final String filePath;
  ReporteTransferenciaStockDownloadSuccess({required this.filePath});
}

class ReporteTransferenciaStockDownloadFailure extends ReporteTransferenciaStockState {
  final String error;
  ReporteTransferenciaStockDownloadFailure({required this.error});
}