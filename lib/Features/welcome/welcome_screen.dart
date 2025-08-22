import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forma/core/utils/app_strings.dart';
import '../../../core/components/primary_button.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layouts/home_layout.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FormaColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              
              SizedBox(height: 60.h),
              
              
              Expanded(
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.welcomeIllustration,
                    height: 300.h,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              
              Text(
                AppStrings.welcomeToForma,
                style: TextStyle(
                  fontSize: 32.sp,
                  color: FormaColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 16.h),
              
              Text(
                AppStrings.yourPersonalFitnessCompanion,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: FormaColors.textSecondary,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 60.h),
              
              
              PrimaryButton(
                title: AppStrings.letStart,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeLayout(),
                    ),
                  );
                },
                buttonColor: FormaColors.primary,
              ),
              
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}