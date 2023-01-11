import 'dart:convert';

import 'package:bicycle_project_app/Model/station_static.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Station extends StatefulWidget {
  const Station({super.key});

  @override
  State<Station> createState() => _StationState();
}

class _StationState extends State<Station> {
  late TextEditingController temp; // 최저기온
  late TextEditingController atemp; // 최고기온
  late TextEditingController humidity; // 습도
  late TextEditingController windspeed; // 풍속
  String result = 'all';

  // 계절
  late List season;
  int seasonNum = 0;

  // 월
  final month = [
    '1월',
    '2월',
    '3월',
    '4월',
    '5월',
    '6월',
    '7월',
    '8월',
    '9월',
    '10월',
    '11월',
    '12월'
  ];
  List month2 = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
  String selectedMonth = '';

  // 공휴일 선택 체크박스
  late bool holiday;
  int holidayNum = 0;

  @override
  void initState() {
    super.initState();
    temp = TextEditingController();
    atemp = TextEditingController();
    humidity = TextEditingController();
    windspeed = TextEditingController();

    print(StationStatic.stationNum);

    // 계절
    season = [true, false, false, false];
    // 월
    selectedMonth = month[0];
    // 공휴일 선택 체크박스
    holiday = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('예측하기'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: temp,
              decoration: const InputDecoration(
                labelText: '최저 기온',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: atemp,
              decoration: const InputDecoration(
                labelText: '최고 기온',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: humidity,
              decoration: const InputDecoration(
                labelText: '습도',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: windspeed,
              decoration: const InputDecoration(
                labelText: '풍속',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '봄',
                ),
                Switch(
                  value: season[0],
                  onChanged: (value) {
                    setState(() {
                      season = [true, false, false, false];
                    });
                  },
                ),
                const Text(
                  '여름',
                ),
                Switch(
                  value: season[1],
                  onChanged: (value) {
                    setState(() {
                      season = [false, true, false, false];
                    });
                  },
                ),
                const Text(
                  '가을',
                ),
                Switch(
                  value: season[2],
                  onChanged: (value) {
                    setState(() {
                      season = [false, false, true, false];
                    });
                  },
                ),
                const Text(
                  '겨울',
                ),
                Switch(
                  value: season[3],
                  onChanged: (value) {
                    setState(() {
                      season = [false, false, false, true];
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton(
                  value: selectedMonth,
                  items: month
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMonth = value!;
                    });
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  '공휴일',
                ),
                Checkbox(
                  value: holiday,
                  onChanged: (value) {
                    setState(() {
                      holiday = value!;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                getJSONData();
              },
              child: const Text(
                '예측하기',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Functions
  getJSONData() async {
    if (season[0] == true) {
      seasonNum = 1;
    } else if (season[1] == true) {
      seasonNum = 2;
    } else if (season[2] == true) {
      seasonNum = 3;
    } else {
      seasonNum = 4;
    }

    if (holiday == true) {
      holidayNum = 1;
    } else {
      holidayNum = 0;
    }

    var url;
    if (StationStatic.stationNum == 2301) {
      print('1');
      url = Uri.parse(
          'http://localhost:8080/RserveFlutter/prediction_bicycle_2301.jsp?temp=${temp.text}&atemp=${atemp.text}&humidity=${humidity.text}&windspeed=${windspeed.text}&season=$seasonNum&month=${selectedMonth.substring(0, 1)}&holiday=$holidayNum');
    } else if (StationStatic.stationNum == 2384) {
      print('2');
      url = Uri.parse(
          'http://localhost:8080/RserveFlutter/prediction_bicycle_2384.jsp?temp=${temp.text}&atemp=${atemp.text}&humidity=${humidity.text}&windspeed=${windspeed.text}&season=$seasonNum&month=${selectedMonth.substring(0, 1)}&holiday=$holidayNum');
    } else if (StationStatic.stationNum == 2342) {
      print('3');
      url = Uri.parse(
          'http://localhost:8080/RserveFlutter/prediction_bicycle_2342.jsp?temp=${temp.text}&atemp=${atemp.text}&humidity=${humidity.text}&windspeed=${windspeed.text}&season=$seasonNum&month=${selectedMonth.substring(0, 1)}&holiday=$holidayNum');
    } else {
      print('4');
      url = Uri.parse(
          'http://localhost:8080/RserveFlutter/prediction_bicycle_2348.jsp?temp=${temp.text}&atemp=${atemp.text}&humidity=${humidity.text}&windspeed=${windspeed.text}&season=$seasonNum&month=${selectedMonth.substring(0, 1)}&holiday=$holidayNum');
    }
    print(url);
    var response = await http.get(url);

    print('-------------');
    print(response.body);
    print('-------------');

    setState(() {
      var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
      result = dataConvertedJSON['result'];
    });
    _showDialog(context, result);
  }

  _showDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('품종 예측 결과'),
          content: Text('입력하신 품종을 $result 입니다.'),
        );
      },
    );
  }
} // End