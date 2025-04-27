import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'login_screen.dart';
import '../constants/color.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: rbackgroundcolor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: AnimatedSplashScreen(
        duration: 3000,
        splashIconSize: double.infinity,
        backgroundColor: rbackgroundcolor,
        centered: true,
        splashTransition: SplashTransition.fadeTransition,
        splash: Image.asset('assets/images/splash.png'),
        nextScreen: LoginScreen(),
        animationDuration: const Duration(milliseconds: 1500),
      ),
    );
  }
}
