import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forma/Features/chatbot/presentation/bloc/chatbot_cubit.dart';
import 'package:forma/Features/chatbot/presentation/screens/chat_bot_screen.dart';
import 'package:forma/Features/home/presentation/screens/home_screen.dart';
import 'package:forma/Features/progress/presentation/screens/progress_screen.dart';
import 'package:forma/Features/settings/presentation/screens/settings_screen.dart';
import 'package:forma/core/components/custom_button_nav_bar.dart';
import 'package:forma/core/utils/app_assets.dart';
import 'package:forma/core/utils/app_strings.dart';
import 'package:forma/core/utils/app_styles.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  HomeLayoutState createState() => HomeLayoutState();
}

class HomeLayoutState extends State<HomeLayout> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const ProgressScreen(),
    BlocProvider(
      create: (context) => ChatbotCubit(),
      child: const ChatBotScreen(),
    ),
    const SettingsScreen(),
  ];

  final List<NavItem> _navItems = [
    const NavItem(icon: AppAssets.homeSvgIcon, label: 'Home'),
    const NavItem(icon: AppAssets.progressSvgIcon, label: 'Progress'),
    const NavItem(icon: AppAssets.chatSvgIcon, label: 'Chat'),
    const NavItem(icon: AppAssets.settingsSvgIcon, label: 'Settings'),
  ];

  @override
  void initState() {
    super.initState();
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _screens[_selectedIndex], // Display the selected screen
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          AppStrings.forma,
          style: AppStyles.headlineLarge(context).copyWith(color: Theme.of(context).colorScheme.primary),
        ),
       
      ),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
        items: _navItems,
      ),
    );
  }

// Helper function to get the icon name based on the index
  String _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return AppAssets.homeSvgIcon;
      // case 1:
      //   return AppIcons.browse; // Browse tab commented out
      case 1:
        return AppAssets.progressSvgIcon;
      case 2:
        return AppAssets.chatSvgIcon;
      case 3:
        return AppAssets.settingsSvgIcon;
      default:
        return AppAssets.homeSvgIcon; // Default icon
    }
  }

// Helper function to get the label for the index
  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Home';
      // case 1:
      //   return 'Browse'; // Browse tab commented out
      case 1:
        return 'Progress';
      case 2:
        return 'Chat';
      case 3:
        return 'Settings';
      default:
        return 'Unknown'; // Default label
    }
  }
}
