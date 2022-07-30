import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:macc/constants.dart';
import 'package:macc/model/user.dart';
import 'package:macc/service/authenticator.dart';
import 'package:shared_preferences/shared_preferences.dart';



part 'authenticator_event.dart';

part 'authenticator_state.dart';

class AuthenticatorBloc
    extends Bloc<AuthenticatorEvent, AuthenticatorState> {
  User? user;
  late SharedPreferences prefs;
  late bool finishedOnBoarding;

  AuthenticatorBloc({this.user})
      : super(const AuthenticatorState.unauthenticated()) {
    on<CheckFirstRunEvent>((event, emit) async {
      prefs = await SharedPreferences.getInstance();
      finishedOnBoarding = prefs.getBool(FINISHED_ON_BOARDING) ?? false;
      if (!finishedOnBoarding) {
        emit(const AuthenticatorState.onboarding());
      } else {
        user = await FireStoreUtils.getAuthUser();
        if (user == null) {
          emit(const AuthenticatorState.unauthenticated());
        } else {
          emit(AuthenticatorState.authenticated(user!));
        }
      }
    });
    on<FinishedOnBoardingEvent>((event, emit) async {
      await prefs.setBool(FINISHED_ON_BOARDING, true);
      emit(const AuthenticatorState.unauthenticated());
    });
    on<LoginWithEmailAndPasswordEvent>((event, emit) async {
      dynamic result = await FireStoreUtils.loginWithEmailAndPassword(
          event.email, event.password);
      if (result != null && result is User) {
        user = result;
        emit(AuthenticatorState.authenticated(user!));
      } else if (result != null && result is String) {
        emit(AuthenticatorState.unauthenticated(message: result));
      } else {
        emit(const AuthenticatorState.unauthenticated(
            message: 'Login failed, Please try again.'));
      }
    });
    on<LoginWithFacebookEvent>((event, emit) async {
      dynamic result = await FireStoreUtils.loginWithFacebook();
      if (result != null && result is User) {
        user = result;
        emit(AuthenticatorState.authenticated(user!));
      } else if (result != null && result is String) {
        emit(AuthenticatorState.unauthenticated(message: result));
      } else {
        emit(const AuthenticatorState.unauthenticated(
            message: 'Facebook login failed, Please try again.'));
      }
    });
    on<LoginWithAppleEvent>((event, emit) async {
      dynamic result = await FireStoreUtils.loginWithApple();
      if (result != null && result is User) {
        user = result;
        emit(AuthenticatorState.authenticated(user!));
      } else if (result != null && result is String) {
        emit(AuthenticatorState.unauthenticated(message: result));
      } else {
        emit(const AuthenticatorState.unauthenticated(
            message: 'Apple login failed, Please try again.'));
      }
    });

    on<LoginWithPhoneNumberEvent>((event, emit) async {
      dynamic result =
      await FireStoreUtils.loginOrCreateUserWithPhoneNumberCredential(
          credential: event.credential,
          phoneNumber: event.phoneNumber,
          firstName: event.firstName,
          lastName: event.lastName,
          image: event.image);
      if (result is User) {
        user = result;
        emit(AuthenticatorState.authenticated(result));
      } else if (result is String) {
        emit(AuthenticatorState.unauthenticated(message: result));
      }
    });
    on<SignupWithEmailAndPasswordEvent>((event, emit) async {
      dynamic result = await FireStoreUtils.signUpWithEmailAndPassword(
          emailAddress: event.emailAddress,
          password: event.password,
          image: event.image,
          firstName: event.firstName,
          lastName: event.lastName);
      if (result != null && result is User) {
        user = result;
        emit(AuthenticatorState.authenticated(user!));
      } else if (result != null && result is String) {
        emit(AuthenticatorState.unauthenticated(message: result));
      } else {
        emit(const AuthenticatorState.unauthenticated(
            message: 'Could not sign up'));
      }
    });
    on<LogoutEvent>((event, emit) async {
      await FireStoreUtils.logout();
      user = null;
      emit(const AuthenticatorState.unauthenticated());
    });
  }
}