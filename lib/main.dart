import 'package:flutter/material.dart';
import 'package:naveyegate/src/view/SplashView.dart';
import 'package:naveyegate/src/viewmodel/ObjectViewModel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ObjectViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'NAVEYEGATE',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashView(),
      ),
    );
  }
}