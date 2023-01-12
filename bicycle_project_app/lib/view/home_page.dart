import 'dart:async';
import 'dart:convert';
import 'package:bicycle_project_app/Model/weather_static.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Map<String, dynamic> selectWeather;
  late String baseDate;
  late String labelDate;
  late String currentbaseTime;
  late String next1;
  late String next2;
  late String next3;
  late String next4;

  @override
  void initState() {
    super.initState();
    baseDate = formatDate(DateTime.now(), [yyyy, mm, dd]);
    labelDate = formatDate(DateTime.now(), [yyyy, '년', mm, '월', dd, '일']);
    currentbaseTime = formatDate(DateTime.now(), [HH, mm]);
    // print('currentTime: $currentbaseTime');
    selectWeather = {};

    getJSONData(baseDate);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getJSONData(baseDate),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        labelDate,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 2.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                int.parse(selectWeather["SKY"]['fcstValue']) < 5
                                    ? const Icon(
                                        Icons.sunny,
                                        size: 100,
                                        color: Color(0xffFFDE00),
                                      )
                                    : int.parse(selectWeather["SKY"]
                                                ['fcstValue']) <
                                            8
                                        ? const Icon(
                                            Icons.cloud,
                                            size: 100,
                                            color: Color(0xff3C79F5),
                                          )
                                        : const Icon(
                                            Icons.cloudy_snowing,
                                            size: 100,
                                            color: Color(0xff3C79F5),
                                          ),
                                Text(
                                  '${selectWeather["TMP"]['fcstValue']}°',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 50,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                int.parse(selectWeather["SKY"]['fcstValue']) < 5
                                    ? '맑음'
                                    : int.parse(selectWeather["SKY"]
                                                ['fcstValue']) <
                                            8
                                        ? '구름 많음'
                                        : '흐림',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('최고 '),
                              Text(
                                '${selectWeather["TMX"]['fcstValue']}° ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text('최저 '),
                              Text(
                                '${selectWeather["TMN"]['fcstValue']}° ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text('풍속 '),
                              Text(
                                '${selectWeather["WSD"]['fcstValue']}m/s ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text('강수 확률 '),
                              Text(
                                '${selectWeather["POP"]['fcstValue']}% ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  pickDate() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      baseDate = formatDate(DateTime.now(), [yyyy, mm, dd]);
      print(baseDate);
    });
  }

  Future<String> getJSONData(String baseDate) async {
    String baseTime;

    // print('hour: ${DateTime.now().hour}');
    // print('minute: ${DateTime.now().minute}');

    // print('currentTime: $currentbaseTime');

    // if (DateTime.now().hour <= 0200) {
    //   // 0200시 이전이라면 전날이어야함

    //   baseDate = (double.parse(formatDate(DateTime.now(), [yyyy, mm, dd])) - 1)
    //       as String;
    // }

    baseTime = int.parse(currentbaseTime) < 0200
        ? "2300"
        : int.parse(currentbaseTime) < 0500
            ? "0200"
            : int.parse(currentbaseTime) < 0800
                ? "0500"
                : int.parse(currentbaseTime) < 1100
                    ? "0800"
                    : int.parse(currentbaseTime) < 1400
                        ? "1100"
                        : int.parse(currentbaseTime) < 1700
                            ? "1400"
                            : int.parse(currentbaseTime) < 2000
                                ? "1700"
                                : "2000";
    var key =
        'EKnVo4X9GAgmVw7dZkmP2uWXbE8dizew4hMPJ5t5L8%2B8%2BIGgBT19eADTmIO2qNJNWEyD8WNghSJbez97er%2FMlw%3D%3D';

    print('baseTime: $baseTime');
    print('baseDate: $baseDate');
    var url = Uri.parse(
        'https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=$key&pageNo=1&numOfRows=1000&dataType=JSON&base_date=$baseDate&base_time=$baseTime&nx=61&ny=126');
    var response = await http.get(url);
    var dataConvertedToJSON = json.decode(response.body);

    List result = dataConvertedToJSON["response"]["body"]["items"]["item"];

    Map<String, dynamic> jsonToMap;

    for (var e in result) {
      jsonToMap = Map<String, dynamic>.from(e);

      if (jsonToMap.values.contains("POP") &&
          jsonToMap.values.contains(baseDate) &&
          jsonToMap.values.contains("0800")) {
        selectWeather["POP"] = jsonToMap;
      }
      if (jsonToMap.values.contains("TMN") &&
          jsonToMap.values.contains(baseDate)) {
        selectWeather["TMN"] = jsonToMap;
      }
      if (jsonToMap.values.contains("TMX") &&
          jsonToMap.values.contains(baseDate)) {
        selectWeather["TMX"] = jsonToMap;
      }
      if (jsonToMap.values.contains("TMP") &&
          jsonToMap.values.contains(baseDate) &&
          jsonToMap.values.contains("0800")) {
        selectWeather["TMP"] = jsonToMap;
      }
      if (jsonToMap.values.contains("REH") &&
          jsonToMap.values.contains(baseDate) &&
          jsonToMap.values.contains("0800")) {
        selectWeather["REH"] = jsonToMap;
      }
      if (jsonToMap.values.contains("SKY") &&
          jsonToMap.values.contains(baseDate) &&
          jsonToMap.values.contains("0800")) {
        selectWeather["SKY"] = jsonToMap;
      }
      if (jsonToMap.values.contains("WSD") &&
          jsonToMap.values.contains(baseDate) &&
          jsonToMap.values.contains("0800")) {
        selectWeather["WSD"] = jsonToMap;
      }
    }

    print('---------- selectWeather: ${selectWeather} -------- \n');

    // static에 필요한 데이터 저장
    weatherStatic.REH = double.parse(selectWeather["REH"]['fcstValue']);
    weatherStatic.TMN = double.parse(selectWeather["TMN"]['fcstValue']);
    weatherStatic.TMX = double.parse(selectWeather["TMX"]['fcstValue']);
    weatherStatic.WSD = double.parse(selectWeather["WSD"]['fcstValue']);

    return "success";
  }
} //END
