import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forma/Features/home/data/models/exercise.dart';
import 'package:forma/Features/home/data/models/logged_exercise.dart';
import 'package:forma/Features/chatbot/data/exercise_api_service.dart';
import 'package:forma/core/helpers/exercise_logger.dart';
import 'package:intl/intl.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailsScreen({
    super.key,
    required this.exercise,
  });

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  Exercise? _detailedExercise;
  bool _isLoading = true;
  bool _isMarkingDone = false;

  @override
  void initState() {
    super.initState();
    _loadExerciseDetails();
  }

  Future<void> _loadExerciseDetails() async {
    try {
      setState(() => _isLoading = true);
      final details = await ExerciseApiService.getExerciseById(widget.exercise.id);
      if (details != null) {
        setState(() {
          _detailedExercise = Exercise.fromJson(details);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _showMarkAsDoneModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _MarkAsDoneModal(
        exercise: _detailedExercise ?? widget.exercise,
      ),
    );
  }

  void _shareExercise() {
    final exercise = _detailedExercise ?? widget.exercise;
    final shareText = '''
🏋️ ${exercise.name}

${exercise.bodyPart != null ? '📍 Body Part: ${exercise.bodyPart}' : ''}
${exercise.equipment != null ? '🔧 Equipment: ${exercise.equipment}' : ''}
${exercise.target != null ? '🎯 Target: ${exercise.target}' : ''}

${exercise.instructions != null && exercise.instructions!.isNotEmpty 
  ? '📋 Instructions:\n${exercise.instructions!.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n')}' 
  : ''}

Shared from Forma Fitness App 💪
    '''.trim();

    Clipboard.setData(ClipboardData(text: shareText));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exercise details copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exercise = _detailedExercise ?? widget.exercise;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareExercise,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise Image
                  if (exercise.gifUrl != null)
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          exercise.gifUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.fitness_center,
                                size: 80,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Exercise Info Cards
                  _buildInfoCard(
                    title: 'Exercise Details',
                    children: [
                      _buildInfoRow('Name', exercise.name),
                      if (exercise.bodyPart != null)
                        _buildInfoRow('Body Part', exercise.bodyPart!),
                      if (exercise.equipment != null)
                        _buildInfoRow('Equipment', exercise.equipment!),
                      if (exercise.target != null)
                        _buildInfoRow('Target Muscle', exercise.target!),
                    ],
                  ),

                  if (exercise.secondaryMuscles != null && exercise.secondaryMuscles!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      title: 'Secondary Muscles',
                      children: [
                        Wrap(
                          spacing: 8,
                          children: exercise.secondaryMuscles!
                              .map((muscle) => Chip(
                                    label: Text(muscle),
                                    backgroundColor: Colors.blue.shade50,
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ],

                  if (exercise.instructions != null && exercise.instructions!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      title: 'Instructions',
                      children: [
                        ...exercise.instructions!.asMap().entries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${entry.key + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _isMarkingDone ? null : _showMarkAsDoneModal,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isMarkingDone
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Mark as Done',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _MarkAsDoneModal extends StatefulWidget {
  final Exercise exercise;

  const _MarkAsDoneModal({required this.exercise});

  @override
  State<_MarkAsDoneModal> createState() => _MarkAsDoneModalState();
}

class _MarkAsDoneModalState extends State<_MarkAsDoneModal> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _durationMinutes = 30;
  bool _isSaving = false;

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _saveExercise() async {
    setState(() => _isSaving = true);

    try {
      // Create exercise data to save
      final exerciseData = {
        'id': widget.exercise.id,
        'name': widget.exercise.name,
        'bodyPart': widget.exercise.bodyPart,
        'equipment': widget.exercise.equipment,
        'target': widget.exercise.target,
        'gifUrl': widget.exercise.gifUrl,
        'secondaryMuscles': widget.exercise.secondaryMuscles,
        'instructions': widget.exercise.instructions,
      };

      // Combine selected date and time
      final selectedDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // Save exercise using ExerciseLogger with custom date
      await ExerciseLogger.logExercise(exerciseData, customDate: selectedDateTime);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.exercise.name} marked as done!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving exercise: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mark as Done',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          Text(
            widget.exercise.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Date Selection
          _buildSelectionTile(
            title: 'Date',
            subtitle: DateFormat('MMM dd, yyyy').format(_selectedDate),
            icon: Icons.calendar_today,
            onTap: _selectDate,
          ),

          // Time Selection
          _buildSelectionTile(
            title: 'Time',
            subtitle: _selectedTime.format(context),
            icon: Icons.access_time,
            onTap: _selectTime,
          ),

          // Duration Selection
          _buildSelectionTile(
            title: 'Duration',
            subtitle: '$_durationMinutes minutes',
            icon: Icons.timer,
            onTap: () => _showDurationDialog(),
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveExercise,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Save Exercise',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSelectionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showDurationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Duration'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: _durationMinutes.toDouble(),
                min: 5,
                max: 120,
                divisions: 23,
                label: '$_durationMinutes minutes',
                onChanged: (value) {
                  setState(() => _durationMinutes = value.round());
                },
              ),
              Text('$_durationMinutes minutes'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              this.setState(() {});
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
