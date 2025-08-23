import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forma/Features/on_boarding/on_boarding_screen.dart';
import 'package:forma/core/theme/app_theme.dart';
import 'package:forma/core/bloc/theme_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc()..add(LoadTheme()),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          ThemeMode themeMode = ThemeMode.system;
          if (state is ThemeLoaded) {
            themeMode = state.themeMode;
          }
          
          return ScreenUtilInit(
            designSize: const Size(375, 812), 
            minTextAdapt: true,
            builder: (context, child) {
              return GetMaterialApp(
                title: 'Forma',
                debugShowCheckedModeBanner: false,
                theme: lightTheme,       
                darkTheme: darkTheme,   
                themeMode: themeMode,
                home: const OnBoardingScreen(),
              );
            },
          );
        },
      ),
    );
  }
}

