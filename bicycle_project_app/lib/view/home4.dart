import 'package:flutter/material.dart';

class Home4 extends StatefulWidget {
  const Home4({super.key});

  @override
  State<Home4> createState() => _Home4State();
}

class _Home4State extends State<Home4> {
  List containers = ["정보 수정", "로그아웃", "일지"];
  List icons = [Icons.person, Icons.logout, Icons.calendar_month];
  List texts = ["정보 수정", "로그아웃", "일지"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: containers.length,
          itemBuilder: (context, position) {
            return GestureDetector(
              onTap: () {
                //
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Icon(
                        icons[position],
                        size: 30,
                        color: const Color(0xff6B778D),
                      ),
                      const SizedBox(width: 8),
                      Text(texts[position],
                          style: const TextStyle(
                              color: Color(0xff525252), fontSize: 16)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
