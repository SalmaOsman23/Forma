import 'package:flutter/material.dart';
import 'package:forma/Features/home/data/models/exercise.dart';
import 'package:forma/Features/chatbot/data/exercise_api_service.dart';

class ExerciseSearchBar extends StatefulWidget {
  final Function(Exercise) onExerciseSelected;
  final VoidCallback onClearSearch;

  const ExerciseSearchBar({
    super.key,
    required this.onExerciseSelected,
    required this.onClearSearch,
  });

  @override
  State<ExerciseSearchBar> createState() => _ExerciseSearchBarState();
}

class _ExerciseSearchBarState extends State<ExerciseSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Exercise> _suggestions = [];
  bool _isLoading = false;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && _searchController.text.isNotEmpty) {
      setState(() => _showSuggestions = true);
    } else if (!_focusNode.hasFocus) {
      setState(() => _showSuggestions = false);
    }
  }

  void _onSearchChanged() async {
    final query = _searchController.text.trim();
    
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      widget.onClearSearch();
      return;
    }

    if (query.length < 2) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final results = await ExerciseApiService.searchExercises(query);
      final exercises = results.take(10).map((e) => Exercise.fromJson(e)).toList();
      
      if (mounted) {
        setState(() {
          _suggestions = exercises;
          _showSuggestions = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _suggestions = [];
          _isLoading = false;
        });
      }
    }
  }

  void _onExerciseSelected(Exercise exercise) {
    _searchController.clear();
    _focusNode.unfocus();
    setState(() {
      _suggestions = [];
      _showSuggestions = false;
    });
    widget.onExerciseSelected(exercise);
  }

  void _clearSearch() {
    _searchController.clear();
    _focusNode.unfocus();
    setState(() {
      _suggestions = [];
      _showSuggestions = false;
    });
    widget.onClearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Search exercises...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: _clearSearch,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onTap: () {
              if (_searchController.text.isNotEmpty) {
                setState(() => _showSuggestions = true);
              }
            },
          ),
        ),

        // Suggestions List
        if (_showSuggestions && (_suggestions.isNotEmpty || _isLoading)) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final exercise = _suggestions[index];
                      return _buildSuggestionTile(exercise);
                    },
                  ),
          ),
        ],
      ],
    );
  }

  Widget _buildSuggestionTile(Exercise exercise) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: exercise.gifUrl != null
              ? Image.network(
                  exercise.gifUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.fitness_center,
                        size: 20,
                        color: Colors.grey,
                      ),
                    );
                  },
                )
              : Container(
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.fitness_center,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
        ),
      ),
      title: Text(
        exercise.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: exercise.bodyPart != null
          ? Text(
              exercise.bodyPart!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            )
          : null,
      onTap: () => _onExerciseSelected(exercise),
    );
  }
}
