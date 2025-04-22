
abstract class ReporteTransferenciaStockEvent {}

class DownloadReportTransferenciaStockEvent extends ReporteTransferenciaStockEvent {
  final String tipoDocumento;
  final int docEntry;

  DownloadReportTransferenciaStockEvent({
    required this.tipoDocumento,
    required this.docEntry,
  });
}