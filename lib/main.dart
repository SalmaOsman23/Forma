import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:forma/Features/on_boarding/on_boarding_screen.dart';
import 'package:forma/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), 
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Forma',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,       
          darkTheme: darkTheme,   
          themeMode: ThemeMode.system, // auto-switch based on device
          home: const OnBoardingScreen(), 
        );
      },
    );
  }
}

