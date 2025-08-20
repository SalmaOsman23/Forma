import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/getwidget.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Color? buttonColor;
  final Color? textColor;
  final Widget? icon;
  final double? size;
  final void Function()? onPressed;
  final GFButtonShape? shape;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.title,
    this.buttonColor,
    this.textColor,
    this.icon,
    this.size,
    this.onPressed,
    this.shape,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.center,
      child: GFButton(
        color: buttonColor ?? theme.primary, 
        disabledColor: (buttonColor ?? theme.primary).withOpacity(0.5),
        blockButton: true,
        shape: shape ?? GFButtonShape.standard,
        size: size ?? 48.h,
        fullWidthButton: true,
        onPressed: isLoading ? null : onPressed,
        borderShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  height: 15.h,
                  width: 15.w,
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: theme.onPrimary.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(theme.onPrimary),
                  ),
                ),
              )
            : Text(
                title,
                style: TextStyle(
                  color: textColor ?? theme.onPrimary, 
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
