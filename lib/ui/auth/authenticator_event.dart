part of 'authenticator_bloc.dart';

abstract class AuthenticatorEvent {}

class LoginWithEmailAndPasswordEvent extends AuthenticatorEvent {
  String email;
  String password;

  LoginWithEmailAndPasswordEvent({required this.email, required this.password});
}

class LoginWithFacebookEvent extends AuthenticatorEvent {}

class LoginWithAppleEvent extends AuthenticatorEvent {}

class LoginWithPhoneNumberEvent extends AuthenticatorEvent {
  auth.PhoneAuthCredential credential;
  String phoneNumber;
  String? firstName, lastName;
  File? image;

  LoginWithPhoneNumberEvent({
    required this.credential,
    required this.phoneNumber,
    this.firstName,
    this.lastName,
    this.image,
  });
}

class SignupWithEmailAndPasswordEvent extends AuthenticatorEvent {
  String emailAddress;
  String password;
  File? image;
  String? firstName;
  String? lastName;

  SignupWithEmailAndPasswordEvent(
      {required this.emailAddress,
        required this.password,
        this.image,
        this.firstName = 'Anonymous',
        this.lastName = 'User'});
}

class LogoutEvent extends AuthenticatorEvent {
  LogoutEvent();
}

class FinishedOnBoardingEvent extends AuthenticatorEvent {}

class CheckFirstRunEvent extends AuthenticatorEvent {}