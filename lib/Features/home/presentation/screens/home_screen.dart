import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forma/Features/home/presentation/bloc/home_cubit.dart';
import 'package:forma/Features/home/presentation/bloc/home_state.dart';
import 'package:forma/Features/home/presentation/widgets/exercise_card.dart';
import 'package:forma/Features/home/presentation/widgets/exercise_filters_widget.dart';
import 'package:forma/Features/home/presentation/widgets/exercise_search_bar.dart';
import 'package:forma/Features/home/presentation/screens/exercise_details_screen.dart';
import 'package:forma/Features/home/data/models/exercise.dart';
import 'package:forma/Features/home/data/models/exercise_filters.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load initial data when the screen is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().loadInitialData();
    });
  }

  void _onExerciseSelected(Exercise exercise) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseDetailsScreen(exercise: exercise),
      ),
    );
  }

  void _onFiltersChanged(ExerciseFilters filters) {
    context.read<HomeCubit>().applyFilters(filters);
  }

  void _onClearFilters() {
    context.read<HomeCubit>().clearFilters();
  }

  void _onClearSearch() {
    context.read<HomeCubit>().clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Exercises'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is HomeLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading exercises...'),
                  ],
                ),
              );
            }

            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading exercises',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeCubit>().loadInitialData();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is HomeLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explore Exercises',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Discover and filter exercises to build your perfect workout',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ExerciseSearchBar(
                        onExerciseSelected: _onExerciseSelected,
                        onClearSearch: _onClearSearch,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Filters
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ExerciseFiltersWidget(
                        equipmentTypes: state.equipmentTypes,
                        targetMuscles: state.targetMuscles,
                        bodyParts: state.bodyParts,
                        currentFilters: state.filters,
                        onFiltersChanged: _onFiltersChanged,
                        onClearFilters: _onClearFilters,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Exercise List Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Exercises',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (state.isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Exercise Count
                    if (state.filters?.hasFilters == true)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '${state.filteredExercises.length} exercises found',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Exercise List
                    state.filteredExercises.isEmpty
                        ? _buildEmptyState(state)
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.filteredExercises.length,
                            itemBuilder: (context, index) {
                              final exercise = state.filteredExercises[index];
                              return ExerciseCard(
                                exercise: exercise,
                                onTap: () => _onExerciseSelected(exercise),
                              );
                            },
                          ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              );
            }

            return const Center(
              child: Text('Unknown state'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(HomeLoaded state) {
    if (state.filters?.hasFilters == true) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_list_off,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No exercises found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search terms',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _onClearFilters,
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No exercises available',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Check your internet connection and try again',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<HomeCubit>().loadInitialData();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}