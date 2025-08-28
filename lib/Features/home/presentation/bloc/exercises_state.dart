import 'package:equatable/equatable.dart';
import 'package:forma/Features/home/data/models/exercise.dart';
import 'package:forma/Features/home/data/models/exercise_filters.dart';

abstract class ExercisesState extends Equatable {
  const ExercisesState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends ExercisesState {}

class HomeLoading extends ExercisesState {}

class HomeLoaded extends ExercisesState {
  final List<Exercise> exercises;
  final List<Exercise> filteredExercises;
  final ExerciseFilters? filters;
  final List<String> equipmentTypes;
  final List<String> targetMuscles;
  final List<String> bodyParts;
  final bool isLoading;

  const HomeLoaded({
    required this.exercises,
    required this.filteredExercises,
    this.filters,
    required this.equipmentTypes,
    required this.targetMuscles,
    required this.bodyParts,
    this.isLoading = false,
  });

  HomeLoaded copyWith({
    List<Exercise>? exercises,
    List<Exercise>? filteredExercises,
    ExerciseFilters? filters,
    List<String>? equipmentTypes,
    List<String>? targetMuscles,
    List<String>? bodyParts,
    bool? isLoading,
  }) {
    return HomeLoaded(
      exercises: exercises ?? this.exercises,
      filteredExercises: filteredExercises ?? this.filteredExercises,
      filters: filters ?? this.filters,
      equipmentTypes: equipmentTypes ?? this.equipmentTypes,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      bodyParts: bodyParts ?? this.bodyParts,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        exercises,
        filteredExercises,
        filters,
        equipmentTypes,
        targetMuscles,
        bodyParts,
        isLoading,
      ];
}

class HomeError extends ExercisesState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}