import 'package:flutter/material.dart';
import 'package:proto_bm2/common/constants.dart';
import 'package:proto_bm2/page/main_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppString.get.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}
