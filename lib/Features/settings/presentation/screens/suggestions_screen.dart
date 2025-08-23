import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/layouts/screen_layout.dart';
import '../../../../core/components/primary_button.dart';
import '../../../../core/utils/app_strings.dart';
class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({super.key});

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _suggestionController = TextEditingController();
  String _selectedCategory = 'General';
  
  final List<String> _categories = [
    AppStrings.general,  
    AppStrings.workoutFeatures,
    AppStrings.uiUxImprovements,
    AppStrings.bugReport,
    AppStrings.newFeatureRequest,
    AppStrings.performance,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _suggestionController.dispose();
    super.dispose();
  }

  void _submitSuggestion() {
    if (_formKey.currentState!.validate()) {
      // Simulate form submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  AppStrings.thankYouYourSuggestionHasBeenSubmittedSuccessfully,
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          margin: EdgeInsets.all(16.w),
        ),
      );
      
      // Clear form
      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _suggestionController.clear();
      setState(() {
        _selectedCategory = 'General';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return ScreenLayout(
      appBarTitle: AppStrings.suggestions,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.helpUsImprove,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                AppStrings.weValueYourFeedbackShareYourSuggestionsReportBugsOrRequestNewFeaturesToHelpUsMakeFormaEvenBetter,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 30.h),
              
              // Category Selection
              Text(
                AppStrings.category,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outline),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down, color: colorScheme.onSurface),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16.sp,
                    ),
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              
              // Name Field
              Text(
                AppStrings.yourNameOptional,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: AppStrings.enterYourName,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                style: TextStyle(color: colorScheme.onSurface),
              ),
              SizedBox(height: 20.h),
              
              // Email Field
              Text(
                AppStrings.emailOptional,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: AppStrings.enterYourEmail,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                style: TextStyle(color: colorScheme.onSurface),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.h),
              
              // Suggestion Field
              Text(
                AppStrings.yourSuggestion,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _suggestionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: AppStrings.describeYourSuggestionBugReportOrFeatureRequestInDetail,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                style: TextStyle(color: colorScheme.onSurface),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.pleaseEnterYourSuggestion;
                  }
                  if (value.trim().length < 10) {
                    return AppStrings.pleaseProvideMoreDetailsAtLeast10Characters;
                  }
                  return null;
                },
              ),
              SizedBox(height: 30.h),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  title: AppStrings.submitSuggestion,
                  onPressed: _submitSuggestion,
                  buttonColor: colorScheme.primary,
                ),
              ),
              
              SizedBox(height: 20.h),
              
              // Info Text
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colorScheme.primary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        AppStrings.yourFeedbackHelpsUsImproveFormaForEveryoneWeReviewAllSuggestionsAndWillConsiderThemForFutureUpdates,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
