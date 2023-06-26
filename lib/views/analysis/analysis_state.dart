abstract class AnalysisState {}

class AnalysisStateInitial extends AnalysisState {}

class AnalysisStateLoading extends AnalysisState {}

class AnalysisStateSuccess extends AnalysisState {}

class AnalysisStateError extends AnalysisState {
  AnalysisStateError({required this.message});

  final String message;
}
