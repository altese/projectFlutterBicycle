import 'package:bicycle_project_app/view/component/my_calendar.dart';
import 'package:bicycle_project_app/view/component/my_container.dart';
import 'package:bicycle_project_app/view/component/my_weather.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              SizedBox(height: 20),
              MyContainer(
                height: 250,
                // ------------------------------- 날씨 위젯
                child: MyWeather(),
              ),
              SizedBox(height: 20),
              MyContainer(
                height: 550,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  // ------------------------------- 캘린더 위젯
                  child: MyCalendar(),
                ),
              ),
              SizedBox(height: 100)
            ],
          ),
        ),
      ),
    );
  }
} //END
