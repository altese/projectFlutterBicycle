import 'package:bicycle_project_app/view/chart_page.dart';
import 'package:bicycle_project_app/view/component/icons/my_flutter_app_icons.dart';
import 'package:bicycle_project_app/view/google_map.dart';
import 'package:bicycle_project_app/view/home_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'home2.dart';
import 'my_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int index;

  @override
  void initState() {
    super.initState();
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    //바텀 바 아이콘
    List pages = const [
      HomePage(),
      SimpleMap(),
      Home2(),
      ChartPage(),
      MyPage()
    ];
    final items = [
      const Icon(Icons.home, size: 30),
      const Icon(Icons.map_rounded, size: 30),
      const Icon(MyFlutterApp.bicycle_2, size: 30),
      const Icon(Icons.bar_chart_rounded, size: 30),
      const Icon(Icons.person, size: 30),
    ];
    return Scaffold(
      //예를들면 사진 바닥까지 꽉채우는것
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 40,
        // 그림자
        elevation: 0.5,
        leading: IconButton(
          onPressed: () {
            Drawer();
          },
          icon: const Icon(
            Icons.menu,
            color: Color(0xFF616161),
          ),
        ),
      ),

      body: pages[index],

      bottomNavigationBar: Theme(
        //아이콘 색깔 설정
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        child: CurvedNavigationBar(
          //굴곡진 빈부분 색깔
          backgroundColor: Colors.transparent,
          //버튼배경색(동그라미)
          buttonBackgroundColor: const Color.fromRGBO(118, 186, 153, 1),
          //바텀탭바 배경색
          color: const Color.fromRGBO(118, 186, 153, 1),
          //클릭시 이동속도
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 240),

          height: 60,
          index: index,
          items: items,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
        ),
      ),
    );
  }
}
