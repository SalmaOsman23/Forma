import 'package:flutter/material.dart';
import 'package:forma/Features/home/data/models/exercise_filters.dart';

class ExerciseFiltersWidget extends StatefulWidget {
  final List<String> equipmentTypes;
  final List<String> targetMuscles;
  final List<String> bodyParts;
  final ExerciseFilters? currentFilters;
  final Function(ExerciseFilters) onFiltersChanged;
  final VoidCallback onClearFilters;

  const ExerciseFiltersWidget({
    super.key,
    required this.equipmentTypes,
    required this.targetMuscles,
    required this.bodyParts,
    this.currentFilters,
    required this.onFiltersChanged,
    required this.onClearFilters,
  });

  @override
  State<ExerciseFiltersWidget> createState() => _ExerciseFiltersWidgetState();
}

class _ExerciseFiltersWidgetState extends State<ExerciseFiltersWidget> {
  ExerciseFilters? _filters;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _filters = widget.currentFilters;
    print('Filter widget initialized with:');
    print('Equipment types: ${widget.equipmentTypes.take(5).toList()}');
    print('Target muscles: ${widget.targetMuscles.take(5).toList()}');
    print('Body parts: ${widget.bodyParts.take(5).toList()}');
  }

  @override
  void didUpdateWidget(ExerciseFiltersWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentFilters != oldWidget.currentFilters) {
      _filters = widget.currentFilters;
    }
  }

  void _updateFilters(ExerciseFilters newFilters) {
    setState(() {
      _filters = newFilters;
    });
    print('Filters updated: $newFilters');
    widget.onFiltersChanged(newFilters);
  }

  void _clearFilters() {
    setState(() {
      _filters = null;
    });
    widget.onClearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter Toggle Button
        Container(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
            label: Text(_isExpanded ? 'Hide Filters' : 'Show Filters'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        if (_isExpanded) ...[
          const SizedBox(height: 16),
          
          // Filters Content
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter Exercises',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_filters?.hasFilters == true)
                      TextButton(
                        onPressed: _clearFilters,
                        child: const Text('Clear All'),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Equipment Filter
                _buildFilterSection(
                  title: 'Equipment',
                  options: widget.equipmentTypes,
                  selectedValue: _filters?.equipment,
                  onChanged: (value) {
                    _updateFilters(_filters?.copyWith(equipment: value) ?? 
                      ExerciseFilters(equipment: value));
                  },
                ),

                const SizedBox(height: 16),

                // Target Muscle Filter
                _buildFilterSection(
                  title: 'Target Muscle',
                  options: widget.targetMuscles,
                  selectedValue: _filters?.target,
                  onChanged: (value) {
                    _updateFilters(_filters?.copyWith(target: value) ?? 
                      ExerciseFilters(target: value));
                  },
                ),

                const SizedBox(height: 16),

                // Body Part Filter
                _buildFilterSection(
                  title: 'Body Part',
                  options: widget.bodyParts,
                  selectedValue: _filters?.bodyPart,
                  onChanged: (value) {
                    _updateFilters(_filters?.copyWith(bodyPart: value) ?? 
                      ExerciseFilters(bodyPart: value));
                  },
                ),

                const SizedBox(height: 16),

                // Active Filters Display
                if (_filters?.hasFilters == true) ...[
                  const Divider(),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      if (_filters?.equipment != null)
                        _buildFilterChip(
                          'Equipment: ${_filters!.equipment}',
                          () => _updateFilters(_filters!.copyWith(equipment: null)),
                        ),
                      if (_filters?.target != null)
                        _buildFilterChip(
                          'Target: ${_filters!.target}',
                          () => _updateFilters(_filters!.copyWith(target: null)),
                        ),
                      if (_filters?.bodyPart != null)
                        _buildFilterChip(
                          'Body Part: ${_filters!.bodyPart}',
                          () => _updateFilters(_filters!.copyWith(bodyPart: null)),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<String> options,
    String? selectedValue,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              final isSelected = selectedValue == option;
              
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (selected) {
                    onChanged(selected ? option : null);
                  },
                  selectedColor: Colors.blue.shade100,
                  checkmarkColor: Colors.blue,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.blue.shade800 : Colors.grey.shade700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: onRemove,
      backgroundColor: Colors.blue.shade50,
      labelStyle: TextStyle(color: Colors.blue.shade800),
    );
  }
}
