import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../Model/rent.dart';

class Chart extends StatefulWidget {
  final String station;

  const Chart({super.key, required this.station});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  late List rentData = [];

  @override
  void initState() {
    super.initState();
    // getData();
    // print(rentData);
  }

  // getData() async {
  //   rentData = await Rent.rentCounts;
  // }

  // 이 값을 기준으로 차트가 바뀜
  // String showAvg = widget.station;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
              color: Color.fromARGB(255, 218, 218, 218),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 12,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(
                // showAvg가 true면 avgData(), false면 mainData() 호출
                widget.station == "2301" ? avgData() : mainData(),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 110,
          height: 34,
          child: TextButton(
            onPressed: () {
              //
            },
            child: const Text(
              '2342 대여소',
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 54, 54, 54),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =================================================================== 하단 x축 라벨
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 3:
        text = const Text('3월', style: style);
        break;
      case 6:
        text = const Text('6월', style: style);
        break;
      case 9:
        text = const Text('9월', style: style);
        break;
      case 12:
        text = const Text('12월', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  // =================================================================== y축 라벨
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 1250:
        text = '1250';
        break;
      case 2500:
        text = '2500';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  // 처음으로 보여줄 차트 2301
  LineChartData mainData() {
    print(Rent.rentCounts);

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color.fromARGB(255, 202, 202, 202),
            // strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color.fromARGB(255, 218, 218, 218),
            // strokeWidth: 1,
          );
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
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: const Color.fromARGB(255, 202, 202, 202),
          )),
      minX: 1,
      maxX: 12,
      minY: 0,
      maxY: 6000,
      lineBarsData: [
        // -------------------------------------------------------- 데이터 넣는 곳!
        LineChartBarData(
          spots: [
            FlSpot(1, double.parse(Rent.rentCounts[0]['rcount'])),
            FlSpot(2, double.parse(Rent.rentCounts[1]['rcount'])),
            FlSpot(3, double.parse(Rent.rentCounts[2]['rcount'])),
            FlSpot(4, double.parse(Rent.rentCounts[3]['rcount'])),
            FlSpot(5, double.parse(Rent.rentCounts[4]['rcount'])),
            FlSpot(6, double.parse(Rent.rentCounts[5]['rcount'])),
            FlSpot(7, double.parse(Rent.rentCounts[6]['rcount'])),
            FlSpot(8, double.parse(Rent.rentCounts[7]['rcount'])),
            FlSpot(9, double.parse(Rent.rentCounts[8]['rcount'])),
            FlSpot(10, double.parse(Rent.rentCounts[9]['rcount'])),
            FlSpot(11, double.parse(Rent.rentCounts[10]['rcount'])),
            FlSpot(12, double.parse(Rent.rentCounts[11]['rcount'])),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  // 버튼 누르면 보여줄 차트
  LineChartData avgData() {
    print(Rent.rentCounts);

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color.fromARGB(255, 202, 202, 202),
            // strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color.fromARGB(255, 218, 218, 218),
            // strokeWidth: 1,
          );
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
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: const Color.fromARGB(255, 202, 202, 202),
          )),
      minX: 1,
      maxX: 12,
      minY: 0,
      maxY: 6000,
      lineBarsData: [
        // -------------------------------------------------------- 데이터 넣는 곳!
        LineChartBarData(
          spots: [
            FlSpot(1, double.parse(Rent.rentCounts[12]['rcount'])),
            FlSpot(2, double.parse(Rent.rentCounts[13]['rcount'])),
            FlSpot(3, double.parse(Rent.rentCounts[14]['rcount'])),
            FlSpot(4, double.parse(Rent.rentCounts[15]['rcount'])),
            FlSpot(5, double.parse(Rent.rentCounts[16]['rcount'])),
            FlSpot(6, double.parse(Rent.rentCounts[17]['rcount'])),
            FlSpot(7, double.parse(Rent.rentCounts[18]['rcount'])),
            FlSpot(8, double.parse(Rent.rentCounts[19]['rcount'])),
            FlSpot(9, double.parse(Rent.rentCounts[20]['rcount'])),
            FlSpot(10, double.parse(Rent.rentCounts[21]['rcount'])),
            FlSpot(11, double.parse(Rent.rentCounts[22]['rcount'])),
            FlSpot(12, double.parse(Rent.rentCounts[23]['rcount'])),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
