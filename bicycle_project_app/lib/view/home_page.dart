import 'dart:async';
import 'dart:convert';
import 'package:bicycle_project_app/Model/station_static.dart';
import 'package:bicycle_project_app/Model/usestatus.dart';
import 'package:bicycle_project_app/Model/weather_static.dart';
import 'package:bicycle_project_app/view/utils.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

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
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  int dialogCnt = 0;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;

        if (!isSameDay(selectedDay, DateTime.now()) &&
            (DateTime.now().compareTo(selectedDay) > 0)) {
          StationStatic.clickedDay = selectedDay.toString().substring(0, 10);
          getJSONDataDaily();
          Future.delayed(Duration(seconds: 1));
          getJSONDataDaily2();
          Future.delayed(Duration(seconds: 1));
          getJSONDataDaily3();
          dialogCnt = 0;
        } else {
          StationStatic.rent2301 = "";
          StationStatic.return2301 = "";
          StationStatic.rent2342 = "";
          StationStatic.return2342 = "";
          StationStatic.rent2348 = "";
          StationStatic.return2348 = "";
          StationStatic.rent2384 = "";
          StationStatic.return2384 = "";
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    baseDate = formatDate(DateTime.now(), [yyyy, mm, dd]);
    labelDate = formatDate(DateTime.now(), [yyyy, '년', mm, '월', dd, '일']);
    currentbaseTime = formatDate(DateTime.now(), [HH, mm]);
    // print('currentTime: $currentbaseTime');
    selectWeather = {};
    initializeDateFormatting('ko_KR', null);

    _selectedDay = _focusedDay;
    getJSONData(baseDate);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
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
                                    int.parse(selectWeather["SKY"]
                                                ['fcstValue']) <
                                            5
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
                                    int.parse(selectWeather["SKY"]
                                                ['fcstValue']) <
                                            5
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
          TableCalendar<Event>(
            locale: 'ko_KR',
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            headerStyle: HeaderStyle(
              titleCentered: true,
              titleTextFormatter: (date, locale) =>
                  DateFormat.yMMMMd(locale).format(date),
              formatButtonVisible: false,
              titleTextStyle: const TextStyle(
                fontSize: 20.0,
                color: Colors.blue,
              ),
              headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
              leftChevronIcon: const Icon(Icons.arrow_left, size: 40.0),
              rightChevronIcon: const Icon(Icons.arrow_right, size: 40.0),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('2301 대여량 : ' +
                  StationStatic.rent2301 +
                  ' 반납량 :' +
                  StationStatic.return2301 +
                  '\n'),
              SizedBox(
                width: 20,
              ),
              Text('2342 대여량 : ' +
                  StationStatic.rent2342 +
                  ' 반납량 :' +
                  StationStatic.return2342 +
                  '\n'),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('2348 대여량 : ' +
                  StationStatic.rent2348 +
                  ' 반납량 :' +
                  StationStatic.return2348 +
                  '\n'),
              SizedBox(
                width: 20,
              ),
              Text('2384 대여량 : ' +
                  StationStatic.rent2384 +
                  ' 반납량 :' +
                  StationStatic.return2384 +
                  '\n'),
            ],
          ),
        ],
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

// Function
  Future<bool> getJSONDataDaily() async {
    var url = Uri.parse(
        'http://openapi.seoul.go.kr:8088/69614676726865733131375661556564/json/tbCycleUseStatus/1/1000/${StationStatic.clickedDay}');
    var response = await http.get(url);
    print(response.body);
    var dateConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    if (dateConvertedJSON['CODE'] == 'INFO-200') {
      _showDialog(context);
      StationStatic.rent2301 = "";
      StationStatic.return2301 = "";
      StationStatic.rent2342 = "";
      StationStatic.return2342 = "";
      StationStatic.rent2348 = "";
      StationStatic.return2348 = "";
      StationStatic.rent2384 = "";
      StationStatic.return2384 = "";
      return false;
    }
    dynamic result = dateConvertedJSON['useStatus']['row']
        .cast<Map<String, dynamic>>()
        .map<UseStatus>((json) => UseStatus.fromJson(json))
        .toList();
    for (int i = 0; i < result.length; i++) {
      if (result[i].rent_nm == "2301. 현대고등학교 건너편") {
        setState(() {
          StationStatic.rent2301 = result[i].rent_cnt;
          StationStatic.return2301 = result[i].rtn_cnt;
        });

        print(result[i].rent_nm);
      } else if (result[i].rent_nm == "2342. 대청역 1번출구  뒤") {
        setState(() {
          StationStatic.rent2342 = result[i].rent_cnt;
          StationStatic.return2342 = result[i].rtn_cnt;
        });
        print(result[i].rent_nm);
      } else if (result[i].rent_nm == "2348. 포스코사거리(기업은행)") {
        setState(() {
          StationStatic.rent2348 = result[i].rent_cnt;
          StationStatic.return2348 = result[i].rtn_cnt;
        });
        print(result[i].rent_nm);
      } else if (result[i].rent_nm == "2384. 자곡사거리") {
        setState(() {
          StationStatic.rent2384 = result[i].rent_cnt;
          StationStatic.return2384 = result[i].rtn_cnt;
        });

        print(result[i].rent_nm);
      }
    }
    return true;
  }

  Future<bool> getJSONDataDaily2() async {
    var url = Uri.parse(
        'http://openapi.seoul.go.kr:8088/69614676726865733131375661556564/json/tbCycleUseStatus/1001/2000/${StationStatic.clickedDay}');
    var response = await http.get(url);
    var dateConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    if (dateConvertedJSON['CODE'] == 'INFO-200') {
      _showDialog(context);
      StationStatic.rent2301 = "";
      StationStatic.return2301 = "";
      StationStatic.rent2342 = "";
      StationStatic.return2342 = "";
      StationStatic.rent2348 = "";
      StationStatic.return2348 = "";
      StationStatic.rent2384 = "";
      StationStatic.return2384 = "";

      return false;
    }
    dynamic result = dateConvertedJSON['useStatus']['row']
        .cast<Map<String, dynamic>>()
        .map<UseStatus>((json) => UseStatus.fromJson(json))
        .toList();
    for (int i = 0; i < result.length; i++) {
      if (result[i].rent_nm == "2301. 현대고등학교 건너편") {
        setState(() {
          StationStatic.rent2301 = result[i].rent_cnt;
          StationStatic.return2301 = result[i].rtn_cnt;
        });

        print(result[i].rent_nm);
      } else if (result[i].rent_nm == "2342. 대청역 1번출구  뒤") {
        setState(() {
          StationStatic.rent2342 = result[i].rent_cnt;
          StationStatic.return2342 = result[i].rtn_cnt;
        });
        print(result[i].rent_nm);
      } else if (result[i].rent_nm == "2348. 포스코사거리(기업은행)") {
        setState(() {
          StationStatic.rent2348 = result[i].rent_cnt;
          StationStatic.return2348 = result[i].rtn_cnt;
        });
        print(result[i].rent_nm);
      } else if (result[i].rent_nm == "2384. 자곡사거리") {
        setState(() {
          StationStatic.rent2384 = result[i].rent_cnt;
          StationStatic.return2384 = result[i].rtn_cnt;
        });

        print(result[i].rent_nm);
      }
    }
    return true;
  }

  Future<bool> getJSONDataDaily3() async {
    var url = Uri.parse(
        'http://openapi.seoul.go.kr:8088/69614676726865733131375661556564/json/tbCycleUseStatus/2001/2682/${StationStatic.clickedDay}');
    var response = await http.get(url);
    var dateConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    if (dateConvertedJSON['CODE'] == 'INFO-200') {
      _showDialog(context);
      StationStatic.rent2301 = "";
      StationStatic.return2301 = "";
      StationStatic.rent2342 = "";
      StationStatic.return2342 = "";
      StationStatic.rent2348 = "";
      StationStatic.return2348 = "";
      StationStatic.rent2384 = "";
      StationStatic.return2384 = "";
      return false;
    }
    dynamic result = dateConvertedJSON['useStatus']['row']
        .cast<Map<String, dynamic>>()
        .map<UseStatus>((json) => UseStatus.fromJson(json))
        .toList();
    for (int i = 0; i < result.length; i++) {
      if (result[i].rent_nm == "2301. 현대고등학교 건너편") {
        setState(() {
          StationStatic.rent2301 = result[i].rent_cnt;
          StationStatic.return2301 = result[i].rtn_cnt;
        });

        print(result[i].rent_nm);
      } else if (result[i].rent_nm == "2342. 대청역 1번출구  뒤") {
        setState(() {
          StationStatic.rent2342 = result[i].rent_cnt;
          StationStatic.return2342 = result[i].rtn_cnt;
        });
        print(result[i].rent_nm);
      } else if (result[i].rent_nm == "2348. 포스코사거리(기업은행)") {
        setState(() {
          StationStatic.rent2348 = result[i].rent_cnt;
          StationStatic.return2348 = result[i].rtn_cnt;
        });
        print(result[i].rent_nm);
      } else if (result[i].rent_nm == "2384. 자곡사거리") {
        setState(() {
          StationStatic.rent2384 = result[i].rent_cnt;
          StationStatic.return2384 = result[i].rtn_cnt;
        });

        print(result[i].rent_nm);
      }
    }
    return true;
  }

  _showDialog(BuildContext context) {
    if (dialogCnt == 0) {
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            content: const Text('확인 불가능'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('대여량과 반납량이 확인되지 않습니다.'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text(
                      '확인',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      );
      dialogCnt = 1;
    }
  }
} //END
