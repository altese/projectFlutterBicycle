import 'dart:convert';
import 'package:bicycle_project_app/view/component/bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/rent.dart';
import 'component/chart.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  // late List data;
  late String station = "";
  List<Color> colorlist = [
    const Color.fromRGBO(234, 250, 209, 1),
    const Color.fromRGBO(181, 226, 218, 1),
    const Color.fromRGBO(147, 197, 243, 1),
    const Color.fromRGBO(160, 164, 253, 1),
  ];

  @override
  void initState() {
    super.initState();
    // data = [];
    getJSONData();
    station = "2301";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      //---------------------------------------------- 2301 버튼 클릭
                      station = "2301";
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: colorlist[0],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 0,
                            blurRadius: 2.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text('2301'),
                    ),
                  ),
                  const SizedBox(width: 25),
                  GestureDetector(
                    onTap: () {
                      //---------------------------------------------- 2342 버튼 클릭
                      station = "2342";
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: colorlist[1],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 0,
                            blurRadius: 2.0,
                            offset: const Offset(
                                0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: const Text('2342'),
                    ),
                  ),
                  const SizedBox(width: 25),
                  GestureDetector(
                    onTap: () {
                      //---------------------------------------------- 2348 버튼 클릭
                      station = "2348";
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: colorlist[2],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 0,
                            blurRadius: 2.0,
                            offset: const Offset(
                                0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: const Text('2348'),
                    ),
                  ),
                  const SizedBox(width: 25),
                  GestureDetector(
                    onTap: () {
                      //---------------------------------------------- 2384 버튼 클릭
                      station = "2384";
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: colorlist[3],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 0,
                            blurRadius: 2.0,
                            offset: const Offset(
                                0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: const Text('2384'),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: getJSONData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Chart(station: station);
                } else {
                  return const Center();
                }
              },
            ),
            const SizedBox(height: 20),
            const MyBarChart(),
          ],
        ),
      ),
    );
  }

  Future<bool> getJSONData() async {
    var url = Uri.parse('http://localhost:8080/Flutter/rent_select_query.jsp');
    var response = await http.get(url);

    Rent.rentCounts.clear();
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];

    // print('---------------------');
    // print('body: ${result}\n');
    // print('---------------------');
    // print('${result[0]['rcount']}');
    // setState(() {
    Rent.rentCounts.addAll(result);
    // Rent.fromMap(result);
    // });
    print('rcount: ${Rent.rentCounts[0]['rcount']}');
    return true;
  }
}//END
