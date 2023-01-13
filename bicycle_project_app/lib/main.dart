import 'package:bicycle_project_app/view/pages/auth_page.dart';
import 'package:bicycle_project_app/view/pages/login_page.dart';
import 'package:bicycle_project_app/view/pages/user_info_update.dart';
import 'package:bicycle_project_app/view/station.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        '/': (context) => const AuthPage(),
        '/station': (context) => const Station(),
        '/userInfoUpdate': (context) => const UserInfoUpdate(),
        '/loginPage': (context) => const LoginPage(),
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
