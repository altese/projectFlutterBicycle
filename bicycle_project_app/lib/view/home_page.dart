import 'dart:async';
import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> selectWeather = [];
  late String baseDate;
  late String labelDate;

  @override
  void initState() {
    super.initState();
    baseDate = formatDate(DateTime.now(), [yyyy, mm, dd]);
    labelDate = formatDate(DateTime.now(), [yyyy, '년', mm, '월', dd, '일']);
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
                                int.parse(selectWeather[2]['fcstValue']) < 5
                                    ? const Icon(
                                        Icons.sunny,
                                        size: 100,
                                        color: Color(0xffFFDE00),
                                      )
                                    : int.parse(selectWeather[2]['fcstValue']) <
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
                                  '${selectWeather[0]['fcstValue']}°',
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
                                int.parse(selectWeather[2]['fcstValue']) < 5
                                    ? '맑음'
                                    : int.parse(selectWeather[2]['fcstValue']) <
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
                                '${selectWeather[5]['fcstValue']}° ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text('최저 '),
                              Text(
                                '${selectWeather[0]['fcstValue']}° ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text('풍속 '),
                              Text(
                                '${selectWeather[1]['fcstValue']}m/s ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text('습도 '),
                              Text(
                                '${selectWeather[4]['fcstValue']}% ',
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

  //---------------------- funcs
  // Future<bool> weatherWithTimer() async {
  //   Timer.periodic(const Duration(seconds: 1), (Timer timer) {
  //     baseDate = formatDate(DateTime.now(), [yyyy, mm, dd]);
  //     print(baseDate);
  //   });
  //   getJSONData();
  //   return true;
  // }

  pickDate() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      baseDate = formatDate(DateTime.now(), [yyyy, mm, dd]);
      print(baseDate);
    });
  }

  Future<String> getJSONData(String baseDate) async {
    // var baseDate = await Timer.periodic(const Duration(seconds: 1), (Timer timer) {
    //   formatDate(DateTime.now(), [yyyy, mm, dd]);
    //   // print(baseDate);
    // });

    var key =
        'EKnVo4X9GAgmVw7dZkmP2uWXbE8dizew4hMPJ5t5L8%2B8%2BIGgBT19eADTmIO2qNJNWEyD8WNghSJbez97er%2FMlw%3D%3D';

    var url = Uri.parse(
        'https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=$key&pageNo=1&numOfRows=1000&dataType=JSON&base_date=$baseDate&base_time=0500&nx=55&ny=127');
    var response = await http.get(url);
    var dataConvertedToJSON = json.decode(response.body);

    print('body: ${response.body}');

    List result = dataConvertedToJSON["response"]["body"]["items"]["item"];

    print(result);

    Map<String, dynamic> jsonToMap;

    for (var e in result) {
      jsonToMap = Map<String, dynamic>.from(e);

      if (jsonToMap.values.contains("POP") &&
          jsonToMap.values.contains(baseDate) &&
          jsonToMap.values.contains("0800")) {
        selectWeather.add(jsonToMap);

        // print(jsonToMap);
      }
      if (jsonToMap.values.contains("TMN") &&
          jsonToMap.values.contains(baseDate)) {
        selectWeather.add(jsonToMap);
        // print(jsonToMap);
      }
      if (jsonToMap.values.contains("TMX") &&
          jsonToMap.values.contains(baseDate)) {
        selectWeather.add(jsonToMap);
        // print(jsonToMap);
      }
      if (jsonToMap.values.contains("TMP") &&
          jsonToMap.values.contains(baseDate) &&
          jsonToMap.values.contains("0800")) {
        selectWeather.add(jsonToMap);
        // print(jsonToMap);
      }
      if (jsonToMap.values.contains("REH") &&
          jsonToMap.values.contains(baseDate) &&
          jsonToMap.values.contains("0800")) {
        selectWeather.add(jsonToMap);
        // print(jsonToMap);
      }
      if (jsonToMap.values.contains("SKY") &&
          jsonToMap.values.contains(baseDate) &&
          jsonToMap.values.contains("0800")) {
        selectWeather.add(jsonToMap);
        // print(jsonToMap);
      }
      if (jsonToMap.values.contains("WSD") &&
          jsonToMap.values.contains(baseDate) &&
          jsonToMap.values.contains("0800")) {
        selectWeather.add(jsonToMap);
        // print(jsonToMap);
      }
      // print("-----");
    }

    print("\n--- selectWeather: $selectWeather---\n");

    print(
        "0: TMP ${selectWeather[0]['category']}, ${selectWeather[0]['fcstValue']}");
    print(
        "1: WSD ${selectWeather[1]['category']}, ${selectWeather[1]['fcstValue']}");
    print(
        "2: SKY ${selectWeather[2]['category']}, ${selectWeather[2]['fcstValue']}");
    print(
        "3: POP ${selectWeather[3]['category']}, ${selectWeather[3]['fcstValue']}");
    print(
        "4: REH ${selectWeather[4]['category']}, ${selectWeather[4]['fcstValue']}");
    print(
        "5: TMX ${selectWeather[5]['category']}, ${selectWeather[5]['fcstValue']}");
    print(
        "6: TMN ${selectWeather[6]['category']}, ${selectWeather[6]['fcstValue']}");

    return "success";
  }
}//END
