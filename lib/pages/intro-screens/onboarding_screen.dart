import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:upbox/pages/authentication/user_login.dart';
import 'package:upbox/pages/intro-screens/page1.dart';
import 'package:upbox/pages/intro-screens/page2.dart';
import 'package:upbox/pages/intro-screens/page3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  // Keeping track of last page
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),

          // After page view is scroll indicator
          Container(
            alignment: const Alignment(0, 0.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // skip
                !onLastPage
                    ? GestureDetector(
                        child: const Text("Skip"),
                        onTap: () {
                          _controller.jumpToPage(2);
                        },
                      )
                    : const Text(""),

                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.orange,
                    dotHeight: 8,
                    dotWidth: 10,
                    dotColor: Color.fromARGB(100, 217, 217, 217),
                  ),
                ),

                // next or done
                onLastPage
                    ? GestureDetector(
                        child: const Text("Done"),
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return const LoginPage();
                            },
                          ));
                        },
                      )
                    : GestureDetector(
                        child: const Text("Next"),
                        onTap: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
