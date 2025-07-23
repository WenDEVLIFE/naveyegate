import 'package:flutter/material.dart';
import 'package:naveyegate/src/services/FirebaseService.dart';
import 'package:naveyegate/src/view/SplashView.dart';
import 'package:naveyegate/src/viewmodel/ObjectViewModel.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());

  await FirebaseService.run();
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