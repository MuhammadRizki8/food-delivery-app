abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class RegistrationInitial extends AuthState {}

class RegistrationLoading extends AuthState {}

class LoginInitial extends AuthState {}

class LoginLoading extends AuthState {}

class RegistrationSuccess extends AuthState {
  final String username;
  final int id;

  RegistrationSuccess({required this.username, required this.id});
}

class RegistrationFailed extends AuthState {
  final String error;

  RegistrationFailed({required this.error});
}

class LoginSuccess extends AuthState {
  final String accessToken;
  LoginSuccess(this.accessToken);
}

class LoginFailed extends AuthState {
  final String error;
  LoginFailed(this.error);
}
