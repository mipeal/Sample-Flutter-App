import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macc/constants.dart' as constants;
import 'package:macc/service/helper.dart';
import 'package:macc/ui/auth/authenticator_bloc.dart';
import 'package:macc/ui/auth/on_boarding/on_boarding_screen.dart';
import 'package:macc/ui/auth/welcome/welcome_screen.dart';
import 'package:macc/ui/home/home_screen.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({Key? key}) : super(key: key);

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthenticatorBloc>().add(CheckFirstRunEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(constants.COLOR_PRIMARY),
      body: BlocListener<AuthenticatorBloc, AuthenticatorState>(
        listener: (context, state) {
          switch (state.authState) {
            case AuthState.firstRun:
              pushReplacement(context, const OnBoardingScreen());
              break;
            case AuthState.authenticated:
              pushReplacement(context, HomeScreen(user: state.user!));
              break;
            case AuthState.unauthenticated:
              pushReplacement(context, const WelcomeScreen());
              break;
          }
        },
        child: const Center(
          child: CircularProgressIndicator.adaptive(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation(Color(constants.COLOR_PRIMARY)),
          ),
        ),
      ),
    );
  }
}