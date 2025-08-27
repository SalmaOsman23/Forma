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
  bool _isEquipmentExpanded = true;
  bool _isTargetExpanded = true;
  bool _isBodyPartExpanded = true;

  @override
  void initState() {
    super.initState();
    _filters = widget.currentFilters;
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Clear All button
        if (_filters?.hasFilters == true) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Filters',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear_all, size: 18),
                label: const Text('Clear All'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red.shade600,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Active filter chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_filters?.equipment != null)
                _buildActiveFilterChip(
                  'Equipment: ${_filters!.equipment}',
                  Icons.fitness_center,
                ),
              if (_filters?.target != null)
                _buildActiveFilterChip(
                  'Target: ${_filters!.target}',
                  Icons.accessibility,
                ),
              if (_filters?.bodyPart != null)
                _buildActiveFilterChip(
                  'Body Part: ${_filters!.bodyPart}',
                  Icons.person,
                ),
            ],
          ),
          const SizedBox(height: 20),
        ],

        // Filter Categories
        Text(
          'Filter by Category',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 16),

        // Equipment Filter
        _buildFilterCategory(
          title: 'Equipment',
          icon: Icons.fitness_center,
          options: widget.equipmentTypes,
          selectedValue: _filters?.equipment,
          isExpanded: _isEquipmentExpanded,
          onToggleExpanded: () {
            setState(() {
              _isEquipmentExpanded = !_isEquipmentExpanded;
            });
          },
          onChanged: (value) {
            _updateFilters(_filters?.copyWith(equipment: value) ?? 
              ExerciseFilters(equipment: value));
          },
        ),

        const SizedBox(height: 20),

        // Target Muscle Filter
        _buildFilterCategory(
          title: 'Target Muscle',
          icon: Icons.accessibility,
          options: widget.targetMuscles,
          selectedValue: _filters?.target,
          isExpanded: _isTargetExpanded,
          onToggleExpanded: () {
            setState(() {
              _isTargetExpanded = !_isTargetExpanded;
            });
          },
          onChanged: (value) {
            _updateFilters(_filters?.copyWith(target: value) ?? 
              ExerciseFilters(target: value));
          },
        ),

        const SizedBox(height: 20),

        // Body Part Filter
        _buildFilterCategory(
          title: 'Body Part',
          icon: Icons.person,
          options: widget.bodyParts,
          selectedValue: _filters?.bodyPart,
          isExpanded: _isBodyPartExpanded,
          onToggleExpanded: () {
            setState(() {
              _isBodyPartExpanded = !_isBodyPartExpanded;
            });
          },
          onChanged: (value) {
            _updateFilters(_filters?.copyWith(bodyPart: value) ?? 
              ExerciseFilters(bodyPart: value));
          },
        ),
      ],
    );
  }

  Widget _buildFilterCategory({
    required String title,
    required IconData icon,
    required List<String> options,
    String? selectedValue,
    required bool isExpanded,
    required VoidCallback onToggleExpanded,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: onToggleExpanded,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                  size: 20,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        if (isExpanded) ...[
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: options.length,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = selectedValue == option;
                
                return Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () => onChanged(isSelected ? null : option),
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected 
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected 
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActiveFilterChip(String label, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
