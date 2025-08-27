import 'package:flutter/material.dart';
import 'package:forma/core/helpers/exercise_logger.dart';
import 'package:forma/core/layouts/home_layout.dart';
import 'package:forma/core/utils/app_strings.dart';
import 'package:intl/intl.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<Map<String, dynamic>> _loggedExercises = [];
  List<Map<String, dynamic>> _filteredExercises = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadLoggedExercises();
  }

  Future<void> _loadLoggedExercises() async {
    try {
      setState(() => _isLoading = true);
      
      // Load logged exercises and stats
      final exercises = await ExerciseLogger.getLoggedExercisesSorted();
      final stats = await ExerciseLogger.getExerciseStats();
      
      setState(() {
        _loggedExercises = exercises;
        _filteredExercises = exercises;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.errorLoadingExercises} ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _refreshData() async {
    setState(() => _isRefreshing = true);
    await _loadLoggedExercises();
    setState(() => _isRefreshing = false);
  }

  void _applyCategoryFilter(String? category) {
    setState(() {
      _selectedCategory = category;
      if (category == null || category == 'All Categories') {
        _filteredExercises = _loggedExercises;
      } else {
        _filteredExercises = _loggedExercises.where((exercise) {
          final bodyPart = exercise['bodyPart'] as String?;
          return bodyPart == category;
        }).toList();
      }
    });
  }

  Future<void> _clearAllLogs() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.clearAllLogs),
        content: const Text(AppStrings.areYouSureYouWantToClearAllLogsThisActionCannotBeUndone),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text(AppStrings.clear),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ExerciseLogger.clearLogs();
        await _loadLoggedExercises();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.allLogsClearedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${AppStrings.errorClearingLogs}: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.progressActivityLogging),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_loggedExercises.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearAllLogs,
              tooltip: AppStrings.clearAllLogs,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _loggedExercises.isEmpty
              ? _buildEmptyState()
              : _buildProgressContent(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.noExercisesCompletedYet,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.completeExercisesFromTheHomeScreenToSeeYourProgressHere,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to home screen (index 0) in the bottom navigation
              final homeLayoutState = context.findAncestorStateOfType<HomeLayoutState>();
              if (homeLayoutState != null) {
                homeLayoutState.onItemTapped(0);
              }
            },
            icon: const Icon(Icons.home),
            label: const Text(AppStrings.goToExercises),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressContent() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Summary
            _buildStatsSummary(),
            const SizedBox(height: 24),
            
            // Exercise List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.completedExercises,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_filteredExercises.length} ${AppStrings.exercises}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Category Filter
            _buildCategoryFilter(),
            const SizedBox(height: 24),
            
            // Exercise List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = _filteredExercises[index];
                return _buildExerciseCard(exercise);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.progressSummary,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  AppStrings.totalExercises,
                  '${_filteredExercises.length}',
                  Icons.fitness_center,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  AppStrings.totalCompletions,
                  '${_filteredExercises.fold<int>(0, (sum, e) => sum + ((e['completedCount'] ?? 1) as int))}',
                  Icons.repeat,
                ),
              ),
            ],
          ),
          if (_stats['mostCompletedExercise'] != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${AppStrings.mostCompleted}: ${_stats['mostCompletedExercise']['name']} (${_stats['mostCompletedExercise']['completedCount']} ${AppStrings.times})',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildExerciseCard(Map<String, dynamic> exercise) {
    final timestamp = exercise['timestamp'] as int?;
    final date = timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : DateTime.now();
    final completedCount = exercise['completedCount'] as int? ?? 1;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  exercise['name'] ?? 'Unknown Exercise',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$completedCount ${completedCount == 1 ? 'time' : 'times'}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          if (exercise['target'] != null) ...[
            Text(
              'Target: ${exercise['target']}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
          ],
          
          Text(
            DateFormat('MMM dd, yyyy - EEEE').format(date),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          
          if (exercise['bodyPart'] != null || exercise['equipment'] != null) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                if (exercise['bodyPart'] != null)
                  Chip(
                    label: Text(exercise['bodyPart']),
                    backgroundColor: Colors.blue.shade50,
                    labelStyle: TextStyle(color: Colors.blue.shade700),
                  ),
                if (exercise['equipment'] != null)
                  Chip(
                    label: Text(exercise['equipment']),
                    backgroundColor: Colors.green.shade50,
                    labelStyle: TextStyle(color: Colors.green.shade700),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    // Get unique categories from logged exercises
    final categories = <String>['All Categories'];
    for (final exercise in _loggedExercises) {
      final bodyPart = exercise['bodyPart'] as String?;
      if (bodyPart != null && !categories.contains(bodyPart)) {
        categories.add(bodyPart);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Filter by Category:',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = _selectedCategory == category || 
                               (category == 'All Categories' && _selectedCategory == null);
              
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () => _applyCategoryFilter(category == 'All Categories' ? null : category),
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Theme.of(context).primaryColor
                          : _getCategoryColor(category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected 
                            ? Theme.of(context).primaryColor
                            : _getCategoryColor(category).withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected 
                            ? Colors.white
                            : _getCategoryColor(category),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'chest':
        return Colors.red;
      case 'back':
        return Colors.blue;
      case 'shoulders':
        return Colors.orange;
      case 'biceps':
        return Colors.green;
      case 'triceps':
        return Colors.purple;
      case 'forearms':
        return Colors.brown;
      case 'upper legs':
        return Colors.indigo;
      case 'lower legs':
        return Colors.teal;
      case 'waist':
        return Colors.pink;
      case 'cardio':
        return Colors.cyan;
      case 'all categories':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}