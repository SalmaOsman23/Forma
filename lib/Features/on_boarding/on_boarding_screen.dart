import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forma/Features/welcome/welcome_screen.dart';
import 'package:forma/core/components/primary_button.dart';
import 'package:forma/core/layouts/home_layout.dart';
import 'package:forma/core/utils/app_assets.dart';
import 'package:forma/core/utils/app_strings.dart';
import 'package:forma/core/utils/app_styles.dart';
import 'package:get/get.dart';
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (!mounted) return;
      
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      
      // Check if the controller is attached before using it
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildOnboardingPage(
                  imagePath: AppAssets.firstWorkoutPic,
                  title: AppStrings.buildYourStrength,
                  subTitle: AppStrings.discoverWorkoutsThatMakeYouStrongerEveryDay,
                ),
                _buildOnboardingPage(
                  imagePath: AppAssets.secondWorkoutPic,
                  title: AppStrings.findYourBalance,
                  subTitle: AppStrings.improveFlexibilityAndStabilityWithGuidedExercises,
                ),
                _buildOnboardingPage(
                  imagePath: AppAssets.thirdWorkoutPic,
                  title: AppStrings.boostYourEnergy,
                  subTitle: AppStrings.stayActiveAndEnergizedWithPersonalizedCardioSessions,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(
      {required String imagePath,
      required String title,
      required String subTitle}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppStyles.onboardingTitle(context),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        Text(
          subTitle,
          style: AppStyles.onboardingSubtitle(context),
          textAlign: TextAlign.center,
        ),
        SvgPicture.asset(
          imagePath,
          width: 300.w,
          height: 300.h,
        ),
        SizedBox(height: 20.h),
        _buildDotsIndicator(),
        SizedBox(height: 20.h),
        PrimaryButton(
          title: _currentPage == 2 ? AppStrings.getStarted : AppStrings.next,
          onPressed: () {
            if (_currentPage == 2) {
              Get.offAll(() => const WelcomeScreen());
            } else {
              // Go to the next page
              if (_pageController.hasClients) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 12 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
