import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BottomIcon extends StatefulWidget {
  final String assetName;
  final bool isSelected;
  final String label;
  final VoidCallback? onTap;
  final bool isLandscape;

  const BottomIcon({
    super.key, 
    required this.assetName, 
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.isLandscape = false,
  });

  @override
  State<BottomIcon> createState() => _BottomIconState();
}

class _BottomIconState extends State<BottomIcon> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void didUpdateWidget(BottomIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive size calculations
    final isSmallScreen = screenHeight < 700;
    final isLargeScreen = screenWidth > 400;
    final isTablet = screenWidth > 600;
    
    // Adjust icon size based on screen size and orientation
    double iconSize;
    if (widget.isLandscape) {
      // Very compact icons for landscape
      if (isSmallScreen) {
        iconSize = 14.w;
      } else if (isTablet) {
        iconSize = 16.w;
      } else {
        iconSize = 15.w;
      }
    } else {
      // Portrait icons
      if (isSmallScreen) {
        iconSize = 18.w;
      } else if (isTablet) {
        iconSize = 22.w;
      } else {
        iconSize = 20.w;
      }
    }
    
    // Adjust padding based on screen size and orientation
    double horizontalPadding;
    double verticalPadding;
    
    if (widget.isLandscape) {
      // Very compact padding for landscape
      horizontalPadding = isLargeScreen ? 6.w : 4.w;
      verticalPadding = 0.5.h;
    } else {
      // Portrait padding
      horizontalPadding = isLargeScreen ? 12.w : 8.w;
      verticalPadding = isSmallScreen ? 3.h : 4.h;
    }
    
    // Adjust font size based on screen size and orientation
    double fontSize;
    if (widget.isLandscape) {
      // Very small fonts for landscape
      if (isSmallScreen) {
        fontSize = 6.sp;
      } else if (isTablet) {
        fontSize = 7.sp;
      } else {
        fontSize = 6.5.sp;
      }
    } else {
      // Portrait fonts
      if (isSmallScreen) {
        fontSize = 8.sp;
      } else if (isTablet) {
        fontSize = 10.sp;
      } else {
        fontSize = 9.sp;
      }
    }
    
    // Adjust spacing between icon and label
    final iconLabelSpacing = widget.isLandscape 
        ? 0.3.h
        : (isSmallScreen ? 1.h : 2.h);

    return GestureDetector(
      onTap: () {
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
        widget.onTap?.call();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.isLandscape ? 12.r : 15.r),
                color: widget.isSelected 
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
                    : Colors.transparent,
                boxShadow: widget.isSelected ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                    blurRadius: widget.isLandscape ? 4 : 6,
                    offset: Offset(0, widget.isLandscape ? 0.5 : 1),
                  ),
                ] : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with bounce animation
                  Transform.translate(
                    offset: Offset(0, -0.5 * _bounceAnimation.value),
                    child: SvgPicture.asset(
                      widget.assetName,
                      width: iconSize,
                      height: iconSize,
                      color: widget.isSelected 
                          ? Theme.of(context).colorScheme.primary 
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: iconLabelSpacing),
                  // Label with fade animation
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: widget.isSelected ? 1.0 : 0.7,
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: widget.isSelected 
                            ? FontWeight.w600 
                            : FontWeight.w400,
                        color: widget.isSelected 
                              ? Theme.of(context).colorScheme.primary 
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
