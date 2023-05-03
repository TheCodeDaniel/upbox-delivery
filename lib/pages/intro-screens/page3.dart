import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset(
          "images/onboarding3.png",
          width: 350,
        ),
      ),
    );
  }
}
