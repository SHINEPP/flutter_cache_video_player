import 'package:example/home_page.dart';
import 'package:flutter/material.dart';
import 'package:fvp/fvp.dart' as fvp;

void main() {
  // 视频播放
  fvp.registerWith();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const HomePage(),
    );
  }
}
