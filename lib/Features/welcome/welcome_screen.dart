import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forma/core/utils/app_strings.dart';
import '../../../core/components/primary_button.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/layouts/home_layout.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
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
                  color: colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 16.h),
              
              Text(
                AppStrings.yourPersonalFitnessCompanion,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: colorScheme.onSurfaceVariant,
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
                buttonColor: colorScheme.primary,
              ),
              
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}