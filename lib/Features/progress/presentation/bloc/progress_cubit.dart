import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forma/Features/progress/presentation/bloc/progress_state.dart';
import 'package:forma/Features/home/data/models/logged_exercise.dart';
import 'package:forma/Features/progress/data/workout_service.dart';

class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit() : super(ProgressInitial());

  Future<void> loadProgressData() async {
    try {
      emit(ProgressLoading());
      
      // Fetch real workout data from the API service
      final workoutLogs = await WorkoutService.generateWorkoutLogs();
      final analytics = await WorkoutService.fetchWorkoutStatistics();
      
      // Extract chart data from analytics
      final chartData = {
        'weeklyWorkoutFrequency': analytics['weeklyWorkoutFrequency'] ?? {},
        'muscleGroupDistribution': analytics['muscleGroupDistribution'] ?? {},
      };
      
      emit(ProgressLoaded(
        workoutLogs: workoutLogs,
        filteredLogs: workoutLogs,
        analytics: analytics,
        chartData: chartData,
      ));
    } catch (e) {
      emit(ProgressError('Failed to load progress data: ${e.toString()}'));
    }
  }

  void applyCategoryFilter(String? category) {
    if (state is! ProgressLoaded) return;

    final currentState = state as ProgressLoaded;
    emit(currentState.copyWith(isLoading: true));

    try {
      List<LoggedExercise> filteredLogs = List.from(currentState.workoutLogs);

      // Apply category filter only
      if (category != null && category.isNotEmpty) {
        filteredLogs = filteredLogs.where((log) {
          return log.exercise.bodyPart == category;
        }).toList();
      }

      emit(currentState.copyWith(
        filteredLogs: filteredLogs,
        selectedCategory: category,
        isLoading: false,
      ));
    } catch (e) {
      emit(currentState.copyWith(isLoading: false));
    }
  }

  void clearFilters() {
    if (state is! ProgressLoaded) return;

    final currentState = state as ProgressLoaded;
    emit(currentState.copyWith(
      filteredLogs: currentState.workoutLogs,
      selectedCategory: null,
    ));
  }

  // Method to refresh workout data from the API
  Future<void> refreshWorkoutData() async {
    try {
      if (state is! ProgressLoaded) return;
      
      emit((state as ProgressLoaded).copyWith(isLoading: true));
      
      final workoutLogs = await WorkoutService.generateWorkoutLogs();
      final analytics = await WorkoutService.fetchWorkoutStatistics();
      
      final chartData = {
        'weeklyWorkoutFrequency': analytics['weeklyWorkoutFrequency'] ?? {},
        'muscleGroupDistribution': analytics['muscleGroupDistribution'] ?? {},
      };
      
      emit((state as ProgressLoaded).copyWith(
        workoutLogs: workoutLogs,
        filteredLogs: workoutLogs,
        analytics: analytics,
        chartData: chartData,
        isLoading: false,
      ));
    } catch (e) {
      if (state is ProgressLoaded) {
        emit((state as ProgressLoaded).copyWith(isLoading: false));
      }
      emit(ProgressError('Failed to refresh workout data: ${e.toString()}'));
    }
  }
}
