
import 'package:flutter/material.dart';
import 'package:naveyegate/src/view/HomeView.dart';

import '../widget/CustomBottomNavigation.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainView> {
  int currentIndex = 0;

  Widget getSelectedPage() {
    switch (currentIndex) {
      case 0:
        return HomeView();
      case 1:
        return HomeView();
      case 2:
        return HomeView();
      case 3:
        return HomeView();
      case 4:
        return HomeView();
      default:
        return HomeView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getSelectedPage(), // Load only the selected page
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}