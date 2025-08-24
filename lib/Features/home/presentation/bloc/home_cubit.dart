import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forma/Features/home/presentation/bloc/home_state.dart';
import 'package:forma/Features/home/data/models/exercise.dart';
import 'package:forma/Features/home/data/models/exercise_filters.dart';
import 'package:forma/Features/chatbot/data/exercise_api_service.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> loadInitialData() async {
    try {
      emit(HomeLoading());
      
      // Load all data in parallel
      final futures = await Future.wait([
        ExerciseApiService.getAllExercises(),
        ExerciseApiService.getEquipmentTypes(),
        ExerciseApiService.getTargetMuscles(),
        ExerciseApiService.getBodyParts(),
      ]);

      final exercises = futures[0].cast<Map<String, dynamic>>().map((e) => Exercise.fromJson(e)).toList();
      final equipmentTypes = futures[1].cast<String>();
      final targetMuscles = futures[2].cast<String>();
      final bodyParts = futures[3].cast<String>();

      print('Loaded ${exercises.length} exercises');
      print('Sample exercise: ${exercises.isNotEmpty ? exercises.first.toString() : 'No exercises'}');
      print('Equipment types: ${equipmentTypes.take(5).toList()}');
      print('Target muscles: ${targetMuscles.take(5).toList()}');
      print('Body parts: ${bodyParts.take(5).toList()}');

      emit(HomeLoaded(
        exercises: exercises,
        filteredExercises: exercises,
        equipmentTypes: equipmentTypes,
        targetMuscles: targetMuscles,
        bodyParts: bodyParts,
      ));
    } catch (e) {
      emit(HomeError('Failed to load exercises: ${e.toString()}'));
    }
  }

  Future<void> searchExercises(String query) async {
    if (query.isEmpty) {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        print('Search cleared, resetting to ${currentState.exercises.length} exercises');
        emit(currentState.copyWith(
          filteredExercises: currentState.exercises,
        ));
      }
      return;
    }

    try {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(currentState.copyWith(isLoading: true));
      }

      print('Searching for: $query');
      final results = await ExerciseApiService.searchExercises(query);
      final exercises = results.map((e) => Exercise.fromJson(e)).toList();
      print('Search results: ${exercises.length} exercises found');

      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(currentState.copyWith(
          filteredExercises: exercises,
          isLoading: false,
        ));
      }
    } catch (e) {
      print('Search error: $e');
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(currentState.copyWith(isLoading: false));
      }
    }
  }

  Future<void> applyFilters(ExerciseFilters filters) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;
    emit(currentState.copyWith(isLoading: true));

    try {
      List<Exercise> filteredExercises = currentState.exercises;

      // Apply filters to the existing exercises list
      if (filters.equipment != null) {
        print('Filtering by equipment: ${filters.equipment}');
        print('Available equipment values: ${filteredExercises.map((e) => e.equipment).where((e) => e != null).toSet().take(10).toList()}');
        filteredExercises = filteredExercises.where((e) => 
          e.equipment != null && 
          e.equipment!.toLowerCase().contains(filters.equipment!.toLowerCase())
        ).toList();
        print('After equipment filter: ${filteredExercises.length} exercises');
      }

      if (filters.target != null) {
        print('Filtering by target: ${filters.target}');
        print('Available target values: ${filteredExercises.map((e) => e.target).where((e) => e != null).toSet().take(10).toList()}');
        filteredExercises = filteredExercises.where((e) => 
          e.target != null && 
          e.target!.toLowerCase().contains(filters.target!.toLowerCase())
        ).toList();
        print('After target filter: ${filteredExercises.length} exercises');
      }

      if (filters.bodyPart != null) {
        print('Filtering by body part: ${filters.bodyPart}');
        print('Available body part values: ${filteredExercises.map((e) => e.bodyPart).where((e) => e != null).toSet().take(10).toList()}');
        filteredExercises = filteredExercises.where((e) => 
          e.bodyPart != null && 
          e.bodyPart!.toLowerCase().contains(filters.bodyPart!.toLowerCase())
        ).toList();
        print('After body part filter: ${filteredExercises.length} exercises');
      }

      emit(currentState.copyWith(
        filteredExercises: filteredExercises,
        filters: filters,
        isLoading: false,
      ));
    } catch (e) {
      emit(currentState.copyWith(isLoading: false));
    }
  }

  void clearFilters() {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;
    print('Clearing filters, resetting to ${currentState.exercises.length} exercises');
    emit(currentState.copyWith(
      filteredExercises: currentState.exercises,
      filters: null,
    ));
  }

  void clearSearch() {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;
    emit(currentState.copyWith(
      filteredExercises: currentState.exercises,
    ));
  }
}
