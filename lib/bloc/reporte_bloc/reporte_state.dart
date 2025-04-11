abstract class ReporteState{}

class ReporteInitial extends ReporteState {}
class ReporteLoading extends ReporteState {}
class ReporteDownloadSuccess extends ReporteState {
  final String filePath;
  ReporteDownloadSuccess({required this.filePath});
}

class ReporteDownloadFailure extends ReporteState {
  final String error;
  ReporteDownloadFailure({required this.error});
}