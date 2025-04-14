import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';
import 'package:restoup_flutter/content_model.dart';
import 'package:restoup_flutter/widget/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  late PageController controller;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (controller.page == contents.length - 1) {
        controller.animateToPage(0,
            duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      } else {
        controller.nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });
  }

  void nextPage() {
    if (currentIndex < contents.length - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipToLastPage() {
    controller.animateToPage(
      contents.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    startTimer();
  }

  @override
  void dispose() {
    controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.5,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.1),
                borderRadius: const BorderRadius.only(),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, right: 16),
                    child: TextButton(
                      onPressed: skipToLastPage,
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Garde le contenu compact
                        children: [
                          const Text(
                            "Sauter",
                            style: TextStyle(
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ),
                          ),
                          Icon(
                            Icons.arrow_right_rounded, // Flèche arrondie
                            color: Colors.black,
                            size: 40, // Légèrement plus grand pour visibilité
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: controller,
                    onPageChanged: (value) => setState(() => currentIndex = value),
                    itemCount: contents.length,
                    itemBuilder: (context, i) => Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.35,
                          child: Image.asset(
                            contents[i].image,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 80),
                        Text(
                          contents[i].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            contents[i].description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.grayColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        SmoothPageIndicator(
                          controller: controller,
                          count: contents.length,
                          effect: const ExpandingDotsEffect(
                            spacing: 5,
                            dotColor:   AppColors.grayColor,
                            activeDotColor: AppColors.accentYellow,
                          ),
                        ),
                        const SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 90),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 6,
                              shadowColor: AppColors.primaryRed,
                              minimumSize: const Size.fromHeight(50),
                            ),
                            onPressed: currentIndex == contents.length - 1
                                ? () {
                                    timer?.cancel();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LoginPage()),
                                      (route) => false,
                                    );
                                  }
                                : nextPage,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  currentIndex == contents.length - 1 ? "Commencer" : "Suivant",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}