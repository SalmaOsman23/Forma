import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forma/core/bloc/theme_bloc.dart';
import 'package:forma/core/theme/app_theme.dart';

class ThemeWrapper extends StatelessWidget {
  final Widget child;

  const ThemeWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        ThemeMode themeMode = ThemeMode.system;
        if (state is ThemeLoaded) {
          themeMode = state.themeMode;
        }

        return Theme(
          data: themeMode == ThemeMode.dark ? darkTheme : lightTheme,
          child: Container(
            color: themeMode == ThemeMode.dark 
                ? FormaColors.backgroundDark 
                : FormaColors.background,
            child: child,
          ),
        );
      },
    );
  }
}
