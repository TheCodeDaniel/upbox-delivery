import 'package:flutter/material.dart';
import 'package:upbox/pages/app_start.dart';
import 'package:upbox/pages/intro-screens/onboarding_screen.dart';
import 'package:upbox/services/auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const AppStart();
        } else {
          return const OnboardingScreen();
        }
      },
    );
  }
}
