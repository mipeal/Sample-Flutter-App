part of 'authenticator_bloc.dart';

enum AuthState { firstRun, authenticated, unauthenticated }

class AuthenticatorState {
  final AuthState authState;
  final User? user;
  final String? message;

  const AuthenticatorState._(this.authState, {this.user, this.message});

  const AuthenticatorState.authenticated(User user)
      : this._(AuthState.authenticated, user: user);

  const AuthenticatorState.unauthenticated({String? message})
      : this._(AuthState.unauthenticated,
      message: message ?? 'Unauthenticated');

  const AuthenticatorState.onboarding() : this._(AuthState.firstRun);
}