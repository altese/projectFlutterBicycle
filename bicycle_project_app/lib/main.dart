import 'package:bicycle_project_app/view/station.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'view/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/station': (context) => const Station(),
      },
      // home: const Home(),
      //getx필요시 오픈
      // getPages: [
      // GetPage(
      // name: "/",
      // page: page,
      // )
      // ],
    );
  }
}
