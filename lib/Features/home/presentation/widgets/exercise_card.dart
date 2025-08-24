import 'package:flutter/material.dart';
import 'package:forma/Features/home/data/models/exercise.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Exercise Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: exercise.gifUrl != null
                      ? Image.network(
                          exercise.gifUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.fitness_center,
                                size: 40,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.fitness_center,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),

              const SizedBox(width: 16),

              // Exercise Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // Exercise Info Tags
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (exercise.bodyPart != null)
                          _buildInfoChip(
                            exercise.bodyPart!,
                            Icons.accessibility,
                            Colors.blue.shade50,
                            Colors.blue.shade700,
                          ),
                        if (exercise.equipment != null)
                          _buildInfoChip(
                            exercise.equipment!,
                            Icons.fitness_center,
                            Colors.green.shade50,
                            Colors.green.shade700,
                          ),
                        if (exercise.target != null)
                          _buildInfoChip(
                            exercise.target!,
                            Icons.my_location,
                            Colors.orange.shade50,
                            Colors.orange.shade700,
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    String label,
    IconData icon,
    Color backgroundColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: backgroundColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
