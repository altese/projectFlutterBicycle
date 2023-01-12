import 'package:bicycle_project_app/Style/my_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../Model/rent.dart';

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

  // late List rentData2301 = [];
  //  FlSpot(1, double.parse(Rent.rentCounts[0]['rcount']))

  @override
  void initState() {
    super.initState();
  }

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
              color: Color.fromARGB(255, 238, 238, 238),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 25,
                left: 12,
                top: 40,
                bottom: 12,
              ),
              child: LineChart(
                // widget.station이 2301, 2342, 2348, 2384일 때 그려지는 차트
                widget.station == "2301"
                    ? chart2301()
                    : widget.station == "2342"
                        ? chart2342()
                        : widget.station == "2348"
                            ? chart2348()
                            : chart2384(),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            width: 150,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: widget.station == "2301"
                  ? MyColors.circleColors[0]
                  : widget.station == "2342"
                      ? MyColors.circleColors[1]
                      : widget.station == "2348"
                          ? MyColors.circleColors[2]
                          : MyColors.circleColors[3],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.center,
                widget.station == "2301"
                    ? '2301 대여소 대여량'
                    : widget.station == "2342"
                        ? '2342 대여소 대여량'
                        : widget.station == "2348"
                            ? '2348 대여소 대여량'
                            : '2384 대여소 대여량',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
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

      case 2500:
        text = '2500';
        break;
      case 5000:
        text = '5000';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  // ===================================================================== chart 2301
  LineChartData chart2301() {
    return LineChartData(
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

  // ===================================================================== chart 2342
  LineChartData chart2342() {
    return LineChartData(
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

  // ===================================================================== chart 2348
  LineChartData chart2348() {
    return LineChartData(
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
            FlSpot(1, double.parse(Rent.rentCounts[24]['rcount'])),
            FlSpot(2, double.parse(Rent.rentCounts[25]['rcount'])),
            FlSpot(3, double.parse(Rent.rentCounts[26]['rcount'])),
            FlSpot(4, double.parse(Rent.rentCounts[27]['rcount'])),
            FlSpot(5, double.parse(Rent.rentCounts[28]['rcount'])),
            FlSpot(6, double.parse(Rent.rentCounts[29]['rcount'])),
            FlSpot(7, double.parse(Rent.rentCounts[30]['rcount'])),
            FlSpot(8, double.parse(Rent.rentCounts[31]['rcount'])),
            FlSpot(9, double.parse(Rent.rentCounts[32]['rcount'])),
            FlSpot(10, double.parse(Rent.rentCounts[33]['rcount'])),
            FlSpot(11, double.parse(Rent.rentCounts[34]['rcount'])),
            FlSpot(12, double.parse(Rent.rentCounts[35]['rcount'])),
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

  // ===================================================================== chart 2384
  LineChartData chart2384() {
    return LineChartData(
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
            FlSpot(1, double.parse(Rent.rentCounts[36]['rcount'])),
            FlSpot(2, double.parse(Rent.rentCounts[37]['rcount'])),
            FlSpot(3, double.parse(Rent.rentCounts[38]['rcount'])),
            FlSpot(4, double.parse(Rent.rentCounts[39]['rcount'])),
            FlSpot(5, double.parse(Rent.rentCounts[40]['rcount'])),
            FlSpot(6, double.parse(Rent.rentCounts[41]['rcount'])),
            FlSpot(7, double.parse(Rent.rentCounts[42]['rcount'])),
            FlSpot(8, double.parse(Rent.rentCounts[43]['rcount'])),
            FlSpot(9, double.parse(Rent.rentCounts[44]['rcount'])),
            FlSpot(10, double.parse(Rent.rentCounts[45]['rcount'])),
            FlSpot(11, double.parse(Rent.rentCounts[46]['rcount'])),
            FlSpot(12, double.parse(Rent.rentCounts[47]['rcount'])),
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
