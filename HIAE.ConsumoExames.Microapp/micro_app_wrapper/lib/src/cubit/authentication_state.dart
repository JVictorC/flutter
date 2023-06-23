import 'package:micro_app_consumo_exame/core/exceptions/exceptions.dart';

abstract class AuthenticationState {}

class AuthenticationInitialState implements AuthenticationState {}

class AuthenticationLoadState implements AuthenticationState {}

class AuthenticationLoadTokenState implements AuthenticationState {}

class AuthenticationSuccessState implements AuthenticationState {
  final String id;

  AuthenticationSuccessState({required this.id});
}

class AuthenticationFailureState implements AuthenticationState {
  final Failure failure;

  AuthenticationFailureState({required this.failure});
}

class AuthenticationValidateTokenState implements AuthenticationState {
  final String token;

  AuthenticationValidateTokenState({required this.token});
}
