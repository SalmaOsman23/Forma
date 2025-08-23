import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forma/core/utils/app_strings.dart';
import '../../../../core/layouts/screen_layout.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return ScreenLayout(
      appBarTitle: AppStrings.faq,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.frequentlyAskedQuestions,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 20.h),
            
            _buildFAQItem(
              context,
              AppStrings.faqFirstQuestion,
              AppStrings.faqFirstAnswer,
            ),
            
            _buildFAQItem(
              context,
              AppStrings.faqSecondQuestion,
              AppStrings.faqSecondAnswer,
            ),
            
            _buildFAQItem(
              context,
              AppStrings.faqThirdQuestion,
              AppStrings.faqThirdAnswer,
            ),
            
            _buildFAQItem(
              context,
              AppStrings.faqFourthQuestion,
              AppStrings.faqFourthAnswer,
            ),
            
            _buildFAQItem(
              context,
              AppStrings.faqFifthQuestion,
              AppStrings.faqFifthAnswer,
            ),
            
            _buildFAQItem(
              context,
              AppStrings.faqSixthQuestion,
              AppStrings.faqSixthAnswer,
            ),
            
            _buildFAQItem(
              context,
              AppStrings.faqSeventhQuestion,
              AppStrings.faqSeventhAnswer,
            ),
            
            _buildFAQItem(
              context,
              AppStrings.faqEighthQuestion,
              AppStrings.faqEighthAnswer,
            ),
            
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                color: colorScheme.primary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  question,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            answer,
            style: TextStyle(
              fontSize: 14.sp,
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
