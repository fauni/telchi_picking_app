
abstract class ReporteEvent {}

class DownloadReportEvent extends ReporteEvent {
  final String tipoDocumento;
  final String docNum;

  DownloadReportEvent({
    required this.tipoDocumento,
    required this.docNum,
  });
}