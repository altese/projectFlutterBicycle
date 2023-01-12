import 'dart:convert';
import 'package:bicycle_project_app/model/station_static.dart';
import 'package:bicycle_project_app/model/weather_static.dart';
import 'package:flutter/material.dart';
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

  // 대여소별 대여량
  late List clusterResult2384;
  late List clusterResult2342;
  late List clusterResult2301;
  late List clusterResult2348;

  // 계절
  late List season;
  int seasonNum = 0;

  // 월
  final monthList = [
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
  String selectedMonth = '';
  late String month;

  // 공휴일 선택 체크박스
  late bool holiday;
  int holidayNum = 0;

  // 현재 시간 가져오기
  late DateTime _toDay;

// ======================================================================

  @override
  void initState() {
    super.initState();
    temp = TextEditingController();
    atemp = TextEditingController();
    humidity = TextEditingController();
    windspeed = TextEditingController();

    // 현재 시간 가져오기
    _toDay = DateTime.now();

    //
    month = '';

    // 계절
    if (_toDay.month.toString() == '1' ||
        _toDay.month.toString() == '2' ||
        _toDay.month.toString() == '12') {
      season = [false, false, false, true];
    } else if (_toDay.month.toString() == '3' ||
        _toDay.month.toString() == '4' ||
        _toDay.month.toString() == '5') {
      season = [true, false, false, false];
    } else if (_toDay.month.toString() == '6' ||
        _toDay.month.toString() == '7' ||
        _toDay.month.toString() == '8') {
      season = [false, true, false, false];
    } else {
      season = [false, false, true, false];
    }

    // 월
    selectedMonth = '${_toDay.month}월';

    // 공휴일 선택 체크박스
    holiday = false;

    clusterResult2384 = [
      '32 ~ 48',
      '46 ~ 51',
      '37 ~ 41',
      '18 ~ 27',
      '69 ~ 77',
      '55 ~ 71',
      '45 ~ 57',
      '50 ~ 57',
      '57 ~ 66',
      '59 ~ 70',
      '18 ~ 26',
      '70 ~ 80',
      '37 ~ 56'
    ];
    clusterResult2342 = [
      '59 ~ 68',
      '78 ~ 90',
      '23 ~ 32',
      '58 ~ 68',
      '82 ~ 87',
      '73 ~ 85',
      '21 ~ 28',
      '72 ~ 81',
      '79 ~ 86',
      '24 ~ 36',
      '20 ~ 32',
      '28 ~ 60',
      '45 ~ 66',
      '22 ~ 27',
      '77 ~ 82'
    ];
    clusterResult2301 = [
      '246 ~ 267',
      '29 ~ 34',
      '150 ~ 178',
      '309 ~ 315',
      '15 ~ 19',
      '135 ~ 180',
      '28 ~ 82',
      '144 ~ 174',
      '35 ~ 68',
      '19 ~ 34',
      '68 ~ 108',
      '80 ~ 106',
      '159 ~ 181',
      '258 ~ 276',
      '16 ~ 25',
      '126 ~ 148',
      '115 ~ 146',
      '196 ~ 225',
      '121 ~ 247',
      '74 ~ 117',
      '244 ~ 308',
      '33 ~ 39',
      '31 ~ 36',
      '13 ~ 27',
      '34 ~ 66',
      '11 ~ 15',
      '15 ~ 92',
      '32 ~ 45',
      '151 ~ 219',
      '18 ~ 27'
    ];

    clusterResult2348 = [
      '38 ~ 68',
      '7 ~ 21',
      '71 ~ 81',
      '59 ~ 73',
      '21 ~ 34',
      '49 ~ 72',
      '34 ~ 43',
      '18 ~ 54',
      '37 ~ 87',
      '72 ~ 92',
      '25 ~ 35',
      '28 ~ 35',
      '28 ~ 35'
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(118, 186, 153, 1),
          title: const Text('예측하기'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        color: Colors.white70,
                        child: TextField(
                          controller: temp,
                          decoration: const InputDecoration(
                            labelText: '최저 기온',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        color: Colors.white60,
                        child: TextField(
                          controller: atemp,
                          decoration: const InputDecoration(
                            labelText: '최고 기온',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        color: Colors.white60,
                        child: TextField(
                          controller: humidity,
                          decoration: const InputDecoration(
                            labelText: '습도',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        color: Colors.white60,
                        child: TextField(
                          controller: windspeed,
                          decoration: const InputDecoration(
                            labelText: '풍속',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ),
                    ),
                  ),
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
                      items: monthList
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectMonth(value!);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (StationStatic.checkMonth == 1 &&
                            temp.text.trim().isNotEmpty &&
                            atemp.text.trim().isNotEmpty &&
                            humidity.text.trim().isNotEmpty &&
                            windspeed.text.trim().isNotEmpty) {
                          getJSONData();
                        } else {
                          checkSelectedValue();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(118, 186, 153, 1)),
                      child: const Text(
                        '예측하기',
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        getWeatherData();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(118, 186, 153, 1)),
                      child: const Text(
                        '날씨 데이터 가져오기',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Functions

  // 예측하기 버튼 클릭 시 실행되는 function
  getJSONData() async {
    // 계절을 숫자로 변경 후 jsp로 전달
    if (season[0] == true) {
      seasonNum = 1; // 봄
    } else if (season[1] == true) {
      seasonNum = 2; // 여름
    } else if (season[2] == true) {
      seasonNum = 3; // 가을
    } else {
      seasonNum = 4; // 겨울
    }

    if (holiday == true) {
      // 공휴일을 숫자로 변경 후 jsp로 전달
      holidayNum = 1; // 공휴일
    } else {
      holidayNum = 0; // 비공휴일
    }

    // 날짜를 숫자로 변경 후 jsp로 전달
    if (selectedMonth == '10월' ||
        selectedMonth == '11월' ||
        selectedMonth == '12월') {
      // 10,11,12월의 경우 substring(0,1)로 하면 앞 글자 1만 출력되기 때문에 0,2로 나누어서 변경함
      month = selectedMonth.substring(0, 2);
    } else {
      month = selectedMonth.substring(0, 1);
    }

    var url;
    if (StationStatic.stationNum == 2301) {
      url = Uri.parse(
          'http://localhost:8080/RserveFlutter/prediction_bicycle_2301.jsp?temp=${temp.text}&atemp=${atemp.text}&humidity=${humidity.text}&windspeed=${windspeed.text}&season=$seasonNum&month=$month&holiday=$holidayNum');
    } else if (StationStatic.stationNum == 2384) {
      url = Uri.parse(
          'http://localhost:8080/RserveFlutter/prediction_bicycle_2384.jsp?temp=${temp.text}&atemp=${atemp.text}&humidity=${humidity.text}&windspeed=${windspeed.text}&season=$seasonNum&month=$month&holiday=$holidayNum');
    } else if (StationStatic.stationNum == 2342) {
      url = Uri.parse(
          'http://localhost:8080/RserveFlutter/prediction_bicycle_2342.jsp?temp=${temp.text}&atemp=${atemp.text}&humidity=${humidity.text}&windspeed=${windspeed.text}&season=$seasonNum&month=$month&holiday=$holidayNum');
    } else {
      url = Uri.parse(
          'http://localhost:8080/RserveFlutter/prediction_bicycle_2348.jsp?temp=${temp.text}&atemp=${atemp.text}&humidity=${humidity.text}&windspeed=${windspeed.text}&season=$seasonNum&month=$month&holiday=$holidayNum');
    }
    var response = await http.get(url);

    setState(() {
      var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
      result = dataConvertedJSON['result'];
    });

    // 시용자가 선택한 대여소에 해당하는 대여량을 출력함
    if (StationStatic.stationNum == 2301) {
      result = clusterResult2301[int.parse(result) - 1];
    } else if (StationStatic.stationNum == 2384) {
      result = clusterResult2384[int.parse(result) - 1];
    } else if (StationStatic.stationNum == 2342) {
      result = clusterResult2342[int.parse(result) - 1];
    } else {
      result = clusterResult2348[int.parse(result) - 1];
    }

    _showDialog(context, result);
  }

  _showDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('대여량 예측 결과'),
          content: Text('${StationStatic.stationNum} 대여소의 대여량은 $result대 입니다.'),
        );
      },
    );
  }

  // 버튼 클릭시 날씨정보 텍스트 필드로 가져오기
  getWeatherData() {
    setState(() {
      temp.text = weatherStatic.TMN.toString();
      atemp.text = weatherStatic.TMX.toString();
      humidity.text = weatherStatic.REH.toString();
      windspeed.text = weatherStatic.WSD.toString();
    });
  }

  // 켜져있는 스위치에 맞춰서 월을 선택할 수 있는 function
  selectMonth(String value) {
    if (season[0] == true) {
      if (value == '1월' ||
          value == '2월' ||
          value == '6월' ||
          value == '7월' ||
          value == '8월' ||
          value == '9월' ||
          value == '10월' ||
          value == '11월' ||
          value == '12월') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$value은 봄이 아닙니다. \n3월, 4월, 5월 중 선택하세요.',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
        StationStatic.checkMonth = 0;
      } else {
        selectedMonth = value;
        StationStatic.checkMonth = 1;
      }
    } else if (season[1] == true) {
      if (value == '1월' ||
          value == '2월' ||
          value == '3월' ||
          value == '4월' ||
          value == '5월' ||
          value == '9월' ||
          value == '10월' ||
          value == '11월' ||
          value == '12월') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$value은 여름이 아닙니다. \n6월, 7월, 8월 중 선택하세요.',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
        StationStatic.checkMonth = 0;
      } else {
        selectedMonth = value;
        StationStatic.checkMonth = 1;
      }
    } else if (season[2] == true) {
      if (value == '1월' ||
          value == '2월' ||
          value == '3월' ||
          value == '4월' ||
          value == '5월' ||
          value == '6월' ||
          value == '7월' ||
          value == '8월' ||
          value == '12월') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$value은 가을이 아닙니다. \n9월, 10월, 11월 중 선택하세요.',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
        StationStatic.checkMonth = 0;
      } else {
        selectedMonth = value;
        StationStatic.checkMonth = 1;
      }
    } else if (season[3] == true) {
      if (value == '3월' ||
          value == '4월' ||
          value == '5월' ||
          value == '6월' ||
          value == '7월' ||
          value == '8월' ||
          value == '9월' ||
          value == '10월' ||
          value == '11월') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$value은 겨울이 아닙니다. \n1월, 2월, 12월 중 선택하세요.',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
        StationStatic.checkMonth = 0;
      } else {
        selectedMonth = value;
        StationStatic.checkMonth = 1;
      }
    }
  }

  checkSelectedValue() {
    if (temp.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '최저 기온을 입력하세요.',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
        ),
      );
    } else if (atemp.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '최고 기온을 입력하세요.',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
        ),
      );
    } else if (humidity.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '습도를 입력하세요.',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
        ),
      );
    } else if (windspeed.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '풍속을 입력하세요.',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
        ),
      );
    } else if (StationStatic.checkMonth == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '계절에 해당하는 월을 선택하세요.',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }
} // End
