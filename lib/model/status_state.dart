abstract class StatusState {}

class StatusInitial extends StatusState {}

class StatusLoading extends StatusState {}

class StatusLoaded extends StatusState {
  final dynamic status;
  StatusLoaded(this.status);
}

class StatusError extends StatusState {
  final String message;
  StatusError(this.message);
}
