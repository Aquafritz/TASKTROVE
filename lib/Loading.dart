import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  final double size;

  const Loading({Key? key, this.size = 100.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/Loading.json', // Adjust the path to your Lottie file
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
