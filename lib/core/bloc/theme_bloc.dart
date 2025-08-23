import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class LoadTheme extends ThemeEvent {}

class ChangeTheme extends ThemeEvent {
  final ThemeMode themeMode;

  const ChangeTheme(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

// States
abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object?> get props => [];
}

class ThemeInitial extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final ThemeMode themeMode;

  const ThemeLoaded(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

class ThemeError extends ThemeState {
  final String message;

  const ThemeError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'theme_mode';

  ThemeBloc() : super(ThemeInitial()) {
    on<LoadTheme>(_onLoadTheme);
    on<ChangeTheme>(_onChangeTheme);
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    try {
      // Try shared_preferences first
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey);
      if (themeIndex != null && themeIndex < ThemeMode.values.length) {
        final themeMode = ThemeMode.values[themeIndex];
        print('ThemeBloc: Loaded theme from storage: $themeMode (index: $themeIndex)');
        emit(ThemeLoaded(themeMode));
        return;
      }
    } catch (e) {
      print('ThemeBloc: Error loading theme from storage: $e');
    }
    
    // Fallback to light theme
    print('ThemeBloc: Using fallback light theme');
    emit(ThemeLoaded(ThemeMode.light));
  }

  Future<void> _onChangeTheme(ChangeTheme event, Emitter<ThemeState> emit) async {
    try {
      // Try to save to shared_preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, event.themeMode.index);
      print('ThemeBloc: Theme saved to storage: ${event.themeMode} (index: ${event.themeMode.index})');
    } catch (e) {
      print('ThemeBloc: Error saving theme to storage: $e');
    }
    
    // Always emit the theme change
    print('ThemeBloc: Emitting theme change: ${event.themeMode}');
    emit(ThemeLoaded(event.themeMode));
    
    // Force a rebuild of the entire app
    print('ThemeBloc: Theme change complete, app should rebuild');
  }

  // Helper getters
  bool get isDarkMode {
    if (state is ThemeLoaded) {
      return (state as ThemeLoaded).themeMode == ThemeMode.dark;
    }
    return false;
  }

  bool get isLightMode {
    if (state is ThemeLoaded) {
      return (state as ThemeLoaded).themeMode == ThemeMode.light;
    }
    return false;
  }

  bool get isSystemMode {
    if (state is ThemeLoaded) {
      return (state as ThemeLoaded).themeMode == ThemeMode.system;
    }
    return true; // Default to system
  }

  ThemeMode get currentThemeMode {
    if (state is ThemeLoaded) {
      return (state as ThemeLoaded).themeMode;
    }
    return ThemeMode.system; // Default to system
  }
}
