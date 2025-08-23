import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forma/core/components/bottom_icon.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavItem> items;

  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and system UI info
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final orientation = MediaQuery.of(context).orientation;
    
    // Responsive calculations
    final isLandscape = orientation == Orientation.landscape;
    final isSmallScreen = screenHeight < 700;
    final isLargeScreen = screenWidth > 400;
    final isTablet = screenWidth > 600;
    
    // Calculate responsive height based on orientation
    double navbarHeight;
    if (isLandscape) {
      // Very compact height for landscape
      if (isSmallScreen) {
        navbarHeight = 35.h;
      } else if (isTablet) {
        navbarHeight = 40.h;
      } else {
        navbarHeight = 38.h;
      }
    } else {
      // Portrait height
      if (isSmallScreen) {
        navbarHeight = 60.h;
      } else if (isTablet) {
        navbarHeight = 75.h;
      } else {
        navbarHeight = 65.h;
      }
    }
    
    final totalHeight = navbarHeight + bottomPadding;
    
    double horizontalPadding;
    double verticalPadding;
    
    if (isLandscape) {
      horizontalPadding = isLargeScreen ? 15.w : 8.w;
      verticalPadding = 1.h;
    } else {
      horizontalPadding = isLargeScreen ? 25.w : 15.w;
      verticalPadding = isSmallScreen ? 4.h : 6.h;
    }
    
    return Container(
      height: totalHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
            blurRadius: isLandscape ? 8 : 15,
            offset: Offset(0, isLandscape ? -1 : -3),
          ),
        ],
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isLandscape ? 12.r : 20.r),
        ),
      ),
      child: Column(
        children: [
          // Main navbar content
          Container(
            height: navbarHeight,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, 
              vertical: verticalPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == currentIndex;
                
                return Expanded(
                  child: BottomIcon(
                    assetName: item.icon,
                    label: item.label,
                    isSelected: isSelected,
                    onTap: () => onTap(index),
                    isLandscape: isLandscape,
                  ),
                );
              }).toList(),
            ),
          ),
          // Bottom safe area spacer
          if (bottomPadding > 0)
            Container(
              height: bottomPadding,
              color: Theme.of(context).colorScheme.surface,
            ),
        ],
      ),
    );
  }
}

class NavItem {
  final String icon;
  final String label;

  const NavItem({
    required this.icon,
    required this.label,
  });
} 