import 'dart:convert';

import 'package:bicycle_project_app/view/utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../Model/station_static.dart';
import '../../Model/usestatus.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({super.key});

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
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
          Future.delayed(const Duration(seconds: 1));
          getJSONDataDaily2();
          Future.delayed(const Duration(seconds: 1));
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
    initializeDateFormatting('ko_KR', null);

    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          calendarStyle: const CalendarStyle(
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
              // color: Color.fromRGBO(118, 186, 153, 1),
            ),
            headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
            leftChevronIcon: const Icon(
              Icons.arrow_left,
              size: 40.0,
              color: Color.fromRGBO(118, 186, 153, 1),
            ),
            rightChevronIcon: const Icon(
              Icons.arrow_right,
              size: 40.0,
              color: Color.fromRGBO(118, 186, 153, 1),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                '2301 대여량 : ${StationStatic.rent2301} 반납량 :${StationStatic.return2301}\n'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                '2342 대여량 : ${StationStatic.rent2342} 반납량 :${StationStatic.return2342}\n'),
          ],
        ),
        // const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                '2348 대여량 : ${StationStatic.rent2348} 반납량 :${StationStatic.return2348}\n'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                '2384 대여량 : ${StationStatic.rent2384} 반납량 :${StationStatic.return2384}\n'),
          ],
        ),
      ],
    );
  }

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
      if (result[i].rentNm == "2301. 현대고등학교 건너편") {
        setState(() {
          StationStatic.rent2301 = result[i].rentCnt;
          StationStatic.return2301 = result[i].rtnCnt;
        });

        print(result[i].rentNm);
      } else if (result[i].rentNm == "2342. 대청역 1번출구  뒤") {
        setState(() {
          StationStatic.rent2342 = result[i].rentCnt;
          StationStatic.return2342 = result[i].rtnCnt;
        });
        print(result[i].rentNm);
      } else if (result[i].rentNm == "2348. 포스코사거리(기업은행)") {
        setState(() {
          StationStatic.rent2348 = result[i].rentCnt;
          StationStatic.return2348 = result[i].rtnCnt;
        });
        print(result[i].rentNm);
      } else if (result[i].rentNm == "2384. 자곡사거리") {
        setState(() {
          StationStatic.rent2384 = result[i].rentCnt;
          StationStatic.return2384 = result[i].rtnCnt;
        });

        print(result[i].rentNm);
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
      if (result[i].rentNm == "2301. 현대고등학교 건너편") {
        setState(() {
          StationStatic.rent2301 = result[i].rentCnt;
          StationStatic.return2301 = result[i].rtnCnt;
        });

        print(result[i].rentNm);
      } else if (result[i].rentNm == "2342. 대청역 1번출구  뒤") {
        setState(() {
          StationStatic.rent2342 = result[i].rentCnt;
          StationStatic.return2342 = result[i].rtnCnt;
        });
        print(result[i].rentNm);
      } else if (result[i].rentNm == "2348. 포스코사거리(기업은행)") {
        setState(() {
          StationStatic.rent2348 = result[i].rentCnt;
          StationStatic.return2348 = result[i].rtnCnt;
        });
        print(result[i].rentNm);
      } else if (result[i].rentNm == "2384. 자곡사거리") {
        setState(() {
          StationStatic.rent2384 = result[i].rentCnt;
          StationStatic.return2384 = result[i].rtnCnt;
        });

        print(result[i].rentNm);
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
      if (result[i].rentNm == "2301. 현대고등학교 건너편") {
        setState(() {
          StationStatic.rent2301 = result[i].rentCnt;
          StationStatic.return2301 = result[i].rtnCnt;
        });

        print(result[i].rentNm);
      } else if (result[i].rentNm == "2342. 대청역 1번출구  뒤") {
        setState(() {
          StationStatic.rent2342 = result[i].rentCnt;
          StationStatic.return2342 = result[i].rtnCnt;
        });
        print(result[i].rentNm);
      } else if (result[i].rentNm == "2348. 포스코사거리(기업은행)") {
        setState(() {
          StationStatic.rent2348 = result[i].rentCnt;
          StationStatic.return2348 = result[i].rtnCnt;
        });
        print(result[i].rentNm);
      } else if (result[i].rentNm == "2384. 자곡사거리") {
        setState(() {
          StationStatic.rent2384 = result[i].rentCnt;
          StationStatic.return2384 = result[i].rtnCnt;
        });

        print(result[i].rentNm);
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
            title: const Text('확인 불가'),
            content: const Text('대여량과 반납량이 확인되지 않습니다.'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text(
                      '확인',
                      style: TextStyle(color: Colors.blue),
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
}
