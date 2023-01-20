import 'dart:async';
import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Model/weather_static.dart';

class MyWeather extends StatefulWidget {
  const MyWeather({super.key});

  @override
  State<MyWeather> createState() => _MyWeatherState();
}

class _MyWeatherState extends State<MyWeather> {
  late String baseDate;
  late String labelDate;
  late String currentbaseTime;

  @override
  void initState() {
    super.initState();

    baseDate = formatDate(DateTime.now(), [yyyy, mm, dd]);
    labelDate = formatDate(DateTime.now(), [yyyy, '년', mm, '월', dd, '일']);
    currentbaseTime = formatDate(DateTime.now(), [HH, mm]);

    getJSONData(baseDate);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getJSONData(baseDate),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [SizedBox(height: 20)],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            '서울특별시 강남구 날씨',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // -------------------------------------------- SKY icon
                              children: [
                                int.parse(WeatherStatic.selectWeather["SKY"]
                                            ['fcstValue']) <
                                        5
                                    ? const Icon(
                                        Icons.sunny,
                                        size: 100,
                                        color: Color(0xffFFDE00),
                                      )
                                    : int.parse(WeatherStatic
                                                    .selectWeather["SKY"]
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
                                // ---------------------------------------------------- TMP
                                Text(
                                  ' ${WeatherStatic.selectWeather["TMP"]['fcstValue']}°',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 50,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ---------------------------------------------------- SKY
                          Text(
                            int.parse(WeatherStatic.selectWeather["SKY"]
                                        ['fcstValue']) <
                                    5
                                ? '맑음'
                                : int.parse(WeatherStatic.selectWeather["SKY"]
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
                          // ---------------------------------------------------- TMX
                          Text(
                            '${WeatherStatic.selectWeather["TMX"]['fcstValue']}° ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text('최저 '),
                          // ---------------------------------------------------- TMN
                          Text(
                            '${WeatherStatic.selectWeather["TMN"]['fcstValue']}° ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text('풍속 '),
                          // ---------------------------------------------------- WSD
                          Text(
                            '${WeatherStatic.selectWeather["WSD"]['fcstValue']}m/s ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text('강수 확률 '),
                          // ---------------------------------------------------- POP
                          Text(
                            '${WeatherStatic.selectWeather["POP"]['fcstValue']}% ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
      },
    );
  }

  // 날씨 api
  Future<String> getJSONData(String baseDate) async {
    String baseTime;
    String fcstTime;

    if (int.parse(currentbaseTime) < 0200) {
      baseDate = '${(double.parse(formatDate(DateTime.now(), [
                yyyy,
                mm,
                dd
              ])).floor() - 1)}';
    } else {
      baseDate = formatDate(DateTime.now(), [yyyy, mm, dd]);
    }

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

    fcstTime = '${(int.parse(baseTime) + 100)}';
    var key =
        'EKnVo4X9GAgmVw7dZkmP2uWXbE8dizew4hMPJ5t5L8%2B8%2BIGgBT19eADTmIO2qNJNWEyD8WNghSJbez97er%2FMlw%3D%3D';

    print('baseTime: $baseTime');
    print('baseDate: $baseDate');
    var url = Uri.parse(
        'https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=$key&pageNo=1&numOfRows=1000&dataType=JSON&base_date=$baseDate&base_time=$baseTime&nx=61&ny=126');
    var urlTmn = Uri.parse(
        'https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=$key&pageNo=1&numOfRows=1000&dataType=JSON&base_date=$baseDate&base_time=0200&nx=61&ny=126');
    var response = await http.get(url);
    var responseTmn = await http.get(urlTmn);
    var dataConvertedToJSON = json.decode(response.body);
    var dataConvertedToJSONTmn = json.decode(responseTmn.body);

    List result = dataConvertedToJSON["response"]["body"]["items"]["item"];
    List resultTmn =
        dataConvertedToJSONTmn["response"]["body"]["items"]["item"];

    Map<String, dynamic> jsonToMap;

    for (var e in result) {
      jsonToMap = Map<String, dynamic>.from(e);

      if (jsonToMap["category"] == "POP" &&
          jsonToMap["fcstDate"] == baseDate &&
          jsonToMap["baseTime"] == baseTime) {
        WeatherStatic.selectWeather["POP"] = jsonToMap;
        print(jsonToMap);
      }
      if (baseTime == "0200" ||
          baseTime == "0500" ||
          baseTime == "0800" ||
          baseTime == "1100") {
        if (jsonToMap["category"] == "TMX" &&
            jsonToMap["fcstDate"] == baseDate) {
          print('tmx1');
          WeatherStatic.selectWeather["TMX"] = jsonToMap;
        }
      } else {
        // ----------------------------- 없으면 일단 30 넣기
        print('no tmx');
        WeatherStatic.selectWeather["TMX"] = {
          'category': "TMX",
          'fcstValue': '20',
        };
      }
      if (jsonToMap["category"] == "TMP" &&
          jsonToMap["fcstDate"] == baseDate &&
          jsonToMap["baseTime"] == baseTime) {
        WeatherStatic.selectWeather["TMP"] = jsonToMap;
      }
      if (jsonToMap.values.contains("REH") &&
          jsonToMap.values.contains(baseDate)) {
        WeatherStatic.selectWeather["REH"] = jsonToMap;
      }
      if (jsonToMap.values.contains("SKY") &&
          jsonToMap.values.contains(baseDate)) {
        WeatherStatic.selectWeather["SKY"] = jsonToMap;
      }
      if (jsonToMap.values.contains("WSD") &&
          jsonToMap.values.contains(baseDate)) {
        WeatherStatic.selectWeather["WSD"] = jsonToMap;
      }
    }

    for (var e in resultTmn) {
      jsonToMap = Map<String, dynamic>.from(e);

      if (jsonToMap["category"] == "TMN" && jsonToMap["fcstDate"] == baseDate) {
        WeatherStatic.selectWeather["TMN"] = jsonToMap;
      }
    }

    print('${WeatherStatic.selectWeather["TMX"]['fcstValue']}');
    print('---------- selectWeather: $WeatherStatic.selectWeather -------- \n');

    // static에 필요한 데이터 저장
    WeatherStatic.REH =
        double.parse(WeatherStatic.selectWeather["REH"]['fcstValue']);
    WeatherStatic.TMN =
        double.parse(WeatherStatic.selectWeather["TMN"]['fcstValue']);
    WeatherStatic.TMX =
        double.parse(WeatherStatic.selectWeather["TMX"]['fcstValue']);
    WeatherStatic.WSD =
        double.parse(WeatherStatic.selectWeather["WSD"]['fcstValue']);

    return "success";
  }
}
