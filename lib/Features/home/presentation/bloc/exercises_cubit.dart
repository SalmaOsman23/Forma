import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forma/Features/home/presentation/bloc/exercises_state.dart';
import 'package:forma/Features/home/data/models/exercise.dart';
import 'package:forma/Features/home/data/models/exercise_filters.dart';
import 'package:forma/Features/chatbot/data/exercise_api_service.dart';

class ExercisesCubit extends Cubit<ExercisesState> {
  ExercisesCubit() : super(HomeInitial()) {
    // Test the filtering logic on initialization
    testFiltering();
  }

  // Test method to verify filtering logic
  void testFiltering() {
    print('=== TESTING FILTERING LOGIC ===');
    
    // Create sample exercises
    final sampleExercises = [
      Exercise(
        id: '1',
        name: 'Push-up',
        bodyPart: 'chest',
        equipment: 'body weight',
        target: 'pectoralis major',
      ),
      Exercise(
        id: '2',
        name: 'Pull-up',
        bodyPart: 'back',
        equipment: 'body weight',
        target: 'latissimus dorsi',
      ),
      Exercise(
        id: '3',
        name: 'Squat',
        bodyPart: 'upper legs',
        equipment: 'body weight',
        target: 'quadriceps',
      ),
    ];
    
    print('Sample exercises:');
    for (final exercise in sampleExercises) {
      print('- ${exercise.name}: bodyPart=${exercise.bodyPart}, equipment=${exercise.equipment}, target=${exercise.target}');
    }
    
    // Test equipment filter
    final equipmentFilter = ExerciseFilters(equipment: 'body weight');
    final equipmentResult = _applyFiltersToExercises(sampleExercises, equipmentFilter);
    print('Equipment filter "body weight": ${equipmentResult.length} results');
    
    // Test body part filter
    final bodyPartFilter = ExerciseFilters(bodyPart: 'chest');
    final bodyPartResult = _applyFiltersToExercises(sampleExercises, bodyPartFilter);
    print('Body part filter "chest": ${bodyPartResult.length} results');
    
    // Test target filter
    final targetFilter = ExerciseFilters(target: 'quadriceps');
    final targetResult = _applyFiltersToExercises(sampleExercises, targetFilter);
    print('Target filter "quadriceps": ${targetResult.length} results');
    
    // Test combined filters
    final combinedFilter = ExerciseFilters(
      equipment: 'body weight',
      bodyPart: 'chest',
    );
    final combinedResult = _applyFiltersToExercises(sampleExercises, combinedFilter);
    print('Combined filter (equipment: body weight, bodyPart: chest): ${combinedResult.length} results');
    
    print('=== END TESTING ===');
  }

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

      print('=== DATA LOADED ===');
      print('Loaded ${exercises.length} exercises');
      
      // Debug: Show sample exercise data
      if (exercises.isNotEmpty) {
        final sampleExercise = exercises.first;
        print('Sample exercise: ${sampleExercise.toString()}');
        print('Sample exercise JSON: ${sampleExercise.toJson()}');
        
        // Show raw API data for first exercise
        if (futures[0].isNotEmpty) {
          print('Raw API data for first exercise: ${futures[0].first}');
        }
      }
      
      // Debug: Show available filter values
      print('Equipment types (first 10): ${equipmentTypes.take(10).toList()}');
      print('Target muscles (first 10): ${targetMuscles.take(10).toList()}');
      print('Body parts (first 10): ${bodyParts.take(10).toList()}');
      
      // Debug: Show unique values from actual exercises
      final uniqueEquipment = exercises.map((e) => e.equipment).where((e) => e != null).toSet().take(10).toList();
      final uniqueTargets = exercises.map((e) => e.target).where((e) => e != null).toSet().take(10).toList();
      final uniqueBodyParts = exercises.map((e) => e.bodyPart).where((e) => e != null).toSet().take(10).toList();
      
      print('Unique equipment from exercises (first 10): $uniqueEquipment');
      print('Unique targets from exercises (first 10): $uniqueTargets');
      print('Unique body parts from exercises (first 10): $uniqueBodyParts');
      
      // Debug: Check for exact matches between filter options and exercise data
      if (equipmentTypes.isNotEmpty && uniqueEquipment.isNotEmpty) {
        final firstFilterOption = equipmentTypes.first;
        final matchingExercises = exercises.where((e) => 
          e.equipment != null && 
          e.equipment!.toLowerCase().trim() == firstFilterOption.toLowerCase().trim()
        ).toList();
        print('Exercises matching first equipment filter option "$firstFilterOption": ${matchingExercises.length}');
        if (matchingExercises.isNotEmpty) {
          print('First match: ${matchingExercises.first.name} - ${matchingExercises.first.equipment}');
        }
      }
      
      print('=== END DATA LOADED ===');

      emit(HomeLoaded(
        exercises: exercises,
        filteredExercises: exercises,
        equipmentTypes: equipmentTypes,
        targetMuscles: targetMuscles,
        bodyParts: bodyParts,
      ));
    } catch (e) {
      print('Error loading initial data: $e');
      emit(HomeError('Failed to load exercises: ${e.toString()}'));
    }
  }

  Future<void> searchExercises(String query) async {
    if (query.isEmpty) {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        print('Search cleared, resetting to ${currentState.exercises.length} exercises');
        
        // If there are active filters, apply them to the base exercises
        List<Exercise> exercisesToShow = currentState.exercises;
        if (currentState.filters != null && currentState.filters!.hasFilters) {
          print('Re-applying filters after search clear');
          exercisesToShow = _applyFiltersToExercises(currentState.exercises, currentState.filters!);
        }
        
        emit(currentState.copyWith(
          filteredExercises: exercisesToShow,
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
        
        // Apply existing filters to search results if any
        List<Exercise> filteredResults = exercises;
        if (currentState.filters != null && currentState.filters!.hasFilters) {
          print('Applying existing filters to search results');
          filteredResults = _applyFiltersToExercises(exercises, currentState.filters!);
        }
        
        emit(currentState.copyWith(
          filteredExercises: filteredResults,
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

  // Helper method to apply filters to a list of exercises
  List<Exercise> _applyFiltersToExercises(List<Exercise> exercises, ExerciseFilters filters) {
    List<Exercise> filteredExercises = List.from(exercises);
    
    print('Helper: Starting with ${filteredExercises.length} exercises');
    
    // Apply equipment filter
    if (filters.equipment != null && filters.equipment!.isNotEmpty) {
      print('Helper: Filtering by equipment: "${filters.equipment}"');
      final beforeCount = filteredExercises.length;
      
      filteredExercises = filteredExercises.where((exercise) {
        if (exercise.equipment == null) return false;
        final exerciseEquipment = exercise.equipment!.toLowerCase().trim();
        final filterEquipment = filters.equipment!.toLowerCase().trim();
        final matches = exerciseEquipment == filterEquipment;
        
        if (matches) {
          print('Helper: Equipment match found: ${exercise.name} has "${exercise.equipment}"');
        }
        
        return matches;
      }).toList();
      
      print('Helper: After equipment filter: ${filteredExercises.length} exercises (was $beforeCount)');
    }

    // Apply target muscle filter
    if (filters.target != null && filters.target!.isNotEmpty) {
      print('Helper: Filtering by target: "${filters.target}"');
      final beforeCount = filteredExercises.length;
      
      filteredExercises = filteredExercises.where((exercise) {
        if (exercise.target == null) return false;
        final exerciseTarget = exercise.target!.toLowerCase().trim();
        final filterTarget = filters.target!.toLowerCase().trim();
        final matches = exerciseTarget == filterTarget;
        
        if (matches) {
          print('Helper: Target match found: ${exercise.name} has "${exercise.target}"');
        }
        
        return matches;
      }).toList();
      
      print('Helper: After target filter: ${filteredExercises.length} exercises (was $beforeCount)');
    }

    // Apply body part filter
    if (filters.bodyPart != null && filters.bodyPart!.isNotEmpty) {
      print('Helper: Filtering by body part: "${filters.bodyPart}"');
      final beforeCount = filteredExercises.length;
      
      filteredExercises = filteredExercises.where((exercise) {
        if (exercise.bodyPart == null) return false;
        final exerciseBodyPart = exercise.bodyPart!.toLowerCase().trim();
        final filterBodyPart = filters.bodyPart!.toLowerCase().trim();
        final matches = exerciseBodyPart == filterBodyPart;
        
        if (matches) {
          print('Helper: Body part match found: ${exercise.name} has "${exercise.bodyPart}"');
        }
        
        return matches;
      }).toList();
      
      print('Helper: After body part filter: ${filteredExercises.length} exercises (was $beforeCount)');
    }
    
    print('Helper: Final result: ${filteredExercises.length} exercises');
    return filteredExercises;
  }

  Future<void> applyFilters(ExerciseFilters filters) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;
    emit(currentState.copyWith(isLoading: true));

    try {
      print('=== APPLYING FILTERS ===');
      print('Original exercises count: ${currentState.exercises.length}');
      print('Filters: $filters');

      // Use the helper method to apply filters
      final filteredExercises = _applyFiltersToExercises(currentState.exercises, filters);

      print('Final filtered exercises count: ${filteredExercises.length}');
      print('=== FILTERS APPLIED ===');

      emit(currentState.copyWith(
        filteredExercises: filteredExercises,
        filters: filters,
        isLoading: false,
      ));
    } catch (e) {
      print('Error applying filters: $e');
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
