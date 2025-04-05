import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:sudofutter/screens/homepage.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset('assets/images/logic9logo.png'),
      backgroundColor: Color(0xFF86A789),
      nextScreen: const HomeScreen(),
      splashIconSize: 250,
      duration: 2000,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(milliseconds: 800),
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
