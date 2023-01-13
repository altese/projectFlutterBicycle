import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

// import 'package:example/utils/color_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyBarChart extends StatefulWidget {
  const MyBarChart({super.key});

  List<Color> get availableColors => const <Color>[
        Colors.purpleAccent,
        Colors.yellow,
        Colors.lightBlue,
        Colors.orange,
        Colors.pink,
        Colors.redAccent,
      ];

  @override
  State<StatefulWidget> createState() => MyBarChartState();
}

class MyBarChartState extends State<MyBarChart> {
  final Color barBackgroundColor = Colors.white;
  final Duration animDuration = const Duration(milliseconds: 250);
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = {};
    getJSONData();
  }

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getJSONData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return AspectRatio(
              aspectRatio: 1,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: const Color.fromARGB(255, 238, 238, 238),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Text(
                            '어제의 대여량',
                            style: TextStyle(
                              // color: Color(0xff0f4a3c),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: BarChart(
                                isPlaying ? randomData() : mainBarData(),
                                swapAnimationDuration: animDuration,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        }

        // child:
        );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = const Color(0xff72d8bf),
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          borderSide: const BorderSide(color: Colors.white, width: 0),
          // isTouched
          //     ? BorderSide(color: Colors.yellow.darken())
          //     : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 60,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(4, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, double.parse(data['2301']['RENT_CNT']),
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, double.parse(data['2342']['RENT_CNT']),
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, double.parse(data['2348']['RENT_CNT']),
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, double.parse(data['2384']['RENT_CNT']),
                isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String rentStation;
            switch (group.x) {
              case 0:
                rentStation = '2301';
                break;
              case 1:
                rentStation = '2342';
                break;
              case 2:
                rentStation = '2348';
                break;
              case 3:
                rentStation = '2384';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$rentStation\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

// x축 라벨
  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      // color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('2301', style: style);
        break;
      case 1:
        text = const Text('2342', style: style);
        break;
      case 2:
        text = const Text('2348', style: style);
        break;
      case 3:
        text = const Text('2384', style: style);
        break;
      // case 4:
      //   text = const Text('F', style: style);
      //   break;
      // case 5:
      //   text = const Text('S', style: style);
      //   break;
      // case 6:
      //   text = const Text('S', style: style);
      //   break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(
              0,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 1:
            return makeGroupData(
              1,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 2:
            return makeGroupData(
              2,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 3:
            return makeGroupData(
              3,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          // case 4:
          //   return makeGroupData(
          //     4,
          //     Random().nextInt(15).toDouble() + 6,
          //     barColor: widget.availableColors[
          //         Random().nextInt(widget.availableColors.length)],
          //   );
          // case 5:
          //   return makeGroupData(
          //     5,
          //     Random().nextInt(15).toDouble() + 6,
          //     barColor: widget.availableColors[
          //         Random().nextInt(widget.availableColors.length)],
          //   );
          // case 6:
          //   return makeGroupData(
          //     6,
          //     Random().nextInt(15).toDouble() + 6,
          //     barColor: widget.availableColors[
          //         Random().nextInt(widget.availableColors.length)],
          // );
          default:
            return throw Error();
        }
      }),
      gridData: FlGridData(show: false),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }

  Future<bool> getJSONData() async {
    String baseDate = formatDate(
        DateTime.now().subtract(const Duration(days: 1)),
        [yyyy, '-', mm, '-', dd]);

    // DateTime.
    formatDate(DateTime.now(), [yyyy, mm, dd]);

    // double baseDate = 20230111;
    print('baseDate: $baseDate');

    var url1000 = Uri.parse(
        'http://openapi.seoul.go.kr:8088/69614676726865733131375661556564/json/tbCycleUseStatus/1/1000/$baseDate');
    var url2000 = Uri.parse(
        'http://openapi.seoul.go.kr:8088/69614676726865733131375661556564/json/tbCycleUseStatus/1001/2000/$baseDate');

    var url3000 = Uri.parse(
        'http://openapi.seoul.go.kr:8088/69614676726865733131375661556564/json/tbCycleUseStatus/2001/3000/$baseDate');

    var response1000 = await http.get(url1000);
    var response2000 = await http.get(url2000);
    var response3000 = await http.get(url3000);

    var dateConvertedJSON1000 =
        json.decode(utf8.decode(response1000.bodyBytes));
    var dateConvertedJSON2000 =
        json.decode(utf8.decode(response2000.bodyBytes));
    var dateConvertedJSON3000 =
        json.decode(utf8.decode(response3000.bodyBytes));

    List result = [];
    List result1000 = dateConvertedJSON1000['useStatus']['row'];
    List result2000 = dateConvertedJSON2000['useStatus']['row'];
    List result3000 = dateConvertedJSON3000['useStatus']['row'];

    result.add(result1000);
    result.add(result2000);
    result.add(result3000);

    print(result[0].length);

    // print(result[0]);
    Map<String, dynamic> jsonToMap;

    for (var e in result[0]) {
      jsonToMap = Map<String, dynamic>.from(e);

      if (jsonToMap.values.contains("2301. 현대고등학교 건너편")) {
        // print('jsonToMap: $jsonToMap');
        print('2301');
        data["2301"] = jsonToMap;
      }

      if (jsonToMap.values.contains("2342. 대청역 1번출구  뒤")) {
        // print('jsonToMap: $jsonToMap');
        data["2342"] = jsonToMap;
      }
      if (jsonToMap.values.contains("2348. 포스코사거리(기업은행)")) {
        // print('jsonToMap: $jsonToMap');
        data["2348"] = jsonToMap;
      }

      if (jsonToMap.values.contains("2384. 자곡사거리")) {
        // print('jsonToMap: $jsonToMap');
        data["2384"] = jsonToMap;
      }
    }
    for (var e in result[1]) {
      jsonToMap = Map<String, dynamic>.from(e);

      if (jsonToMap.values.contains("2301. 현대고등학교 건너편")) {
        // print('jsonToMap: $jsonToMap');
        print('2301');
        data["2301"] = jsonToMap;
      }

      if (jsonToMap.values.contains("2342. 대청역 1번출구  뒤")) {
        // print('jsonToMap: $jsonToMap');
        data["2342"] = jsonToMap;
      }
      if (jsonToMap.values.contains("2348. 포스코사거리(기업은행)")) {
        // print('jsonToMap: $jsonToMap');
        data["2348"] = jsonToMap;
      }

      if (jsonToMap.values.contains("2384. 자곡사거리")) {
        // print('jsonToMap: $jsonToMap');
        data["2384"] = jsonToMap;
      }
    }
    for (var e in result[2]) {
      jsonToMap = Map<String, dynamic>.from(e);

      if (jsonToMap.values.contains("2301. 현대고등학교 건너편")) {
        // print('jsonToMap: $jsonToMap');
        print('2301');
        data["2301"] = jsonToMap;
      }

      if (jsonToMap.values.contains("2342. 대청역 1번출구  뒤")) {
        // print('jsonToMap: $jsonToMap');
        data["2342"] = jsonToMap;
      }
      if (jsonToMap.values.contains("2348. 포스코사거리(기업은행)")) {
        // print('jsonToMap: $jsonToMap');
        data["2348"] = jsonToMap;
      }

      if (jsonToMap.values.contains("2384. 자곡사거리")) {
        // print('jsonToMap: $jsonToMap');
        data["2384"] = jsonToMap;
      }
    }

    print(data);
    return true;
  }
}
