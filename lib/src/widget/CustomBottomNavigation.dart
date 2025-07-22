import 'package:flutter/material.dart';
import 'package:naveyegate/src/helpers/ColorHelper.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: ColorHelper.primaryColor ,
      selectedItemColor: Colors.white,
      unselectedItemColor: ColorHelper.primaryContainer,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt_outlined),
          label: 'Scan',
        ),
      ],
    );
  }
}