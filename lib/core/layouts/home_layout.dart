import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forma/Features/chatbot/presentation/bloc/chatbot_cubit.dart';
import 'package:forma/Features/chatbot/presentation/screens/chat_bot_screen.dart';
import 'package:forma/Features/home/presentation/bloc/exercises_cubit.dart';
import 'package:forma/Features/home/presentation/screens/exercise_screen.dart';

import 'package:forma/Features/progress/presentation/screens/progress_screen.dart';
import 'package:forma/Features/settings/presentation/screens/settings_screen.dart';
import 'package:forma/core/components/custom_button_nav_bar.dart';
import 'package:forma/core/utils/app_assets.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  HomeLayoutState createState() => HomeLayoutState();
}

class HomeLayoutState extends State<HomeLayout> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    BlocProvider(
      create: (context) => ExercisesCubit(),
      child: const ExercisesScreen(),
    ),
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
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
        items: _navItems,
      ),
    );
  }


}
