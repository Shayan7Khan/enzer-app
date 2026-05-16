import 'package:enzer_app/core/others/base_view_model.dart';
import 'package:enzer_app/ui/screens/about_screen/about_screen.dart';
import 'package:enzer_app/ui/screens/activity_screen/activity_screen.dart';
import 'package:enzer_app/ui/screens/home_screen/home_screen.dart';
import 'package:enzer_app/ui/screens/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';

class RootScreenViewModel extends BaseViewModel {
  int selectedScreen = 0;
  bool isEnableBottomBar = true;

  // list of screens
  final List<Widget> allScreen = [
    HomeScreen(),
    AboutScreen(),
    ActivityScreen(),
    ProfileScreen(),
  ];

  void updatedScreenIndex(int index) {
    selectedScreen = index;
    notifyListeners();
  }
}
