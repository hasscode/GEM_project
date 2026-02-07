abstract class InitializationState {}

class InitializationInitial extends InitializationState {}

class InitializationLoading extends InitializationState {}

class InitializationEmpty extends InitializationState {}

class InitializationReady extends InitializationState {}

class InitializationImported extends InitializationState {}

class InitializationError extends InitializationState {
  final String message;

  InitializationError(this.message);
}
