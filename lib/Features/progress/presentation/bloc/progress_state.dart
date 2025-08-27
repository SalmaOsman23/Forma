import 'package:equatable/equatable.dart';
import 'package:forma/Features/home/data/models/logged_exercise.dart';

abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressLoaded extends ProgressState {
  final List<LoggedExercise> workoutLogs;
  final List<LoggedExercise> filteredLogs;
  final Map<String, dynamic> analytics;
  final Map<String, dynamic> chartData;
  final String? selectedCategory;
  final bool isLoading;

  const ProgressLoaded({
    required this.workoutLogs,
    required this.filteredLogs,
    required this.analytics,
    required this.chartData,
    this.selectedCategory,
    this.isLoading = false,
  });

  ProgressLoaded copyWith({
    List<LoggedExercise>? workoutLogs,
    List<LoggedExercise>? filteredLogs,
    Map<String, dynamic>? analytics,
    Map<String, dynamic>? chartData,
    String? selectedCategory,
    bool? isLoading,
  }) {
    return ProgressLoaded(
      workoutLogs: workoutLogs ?? this.workoutLogs,
      filteredLogs: filteredLogs ?? this.filteredLogs,
      analytics: analytics ?? this.analytics,
      chartData: chartData ?? this.chartData,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        workoutLogs,
        filteredLogs,
        analytics,
        chartData,
        selectedCategory,
        isLoading,
      ];
}

class ProgressError extends ProgressState {
  final String message;

  const ProgressError(this.message);

  @override
  List<Object?> get props => [message];
}
