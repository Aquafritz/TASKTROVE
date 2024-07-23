import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tasktroveprojects/screens/Auth/SignInScreen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
           begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF8C52FF),
            Color(0xFFFF914D),
          ],
        ),
      ),
      child: AnimatedSplashScreen(
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: LottieBuilder.asset(
                  'assets/animations/splash_screen.json',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        nextScreen: SignInScreen(), // Change to your desired screen
        splashIconSize: 400,
        duration: 2500,
        backgroundColor: Colors.transparent, // Set to transparent to see the gradient
      ),
    );
  }
}