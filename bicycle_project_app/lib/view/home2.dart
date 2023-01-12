import 'dart:convert';

import 'package:bicycle_project_app/model/message.dart';
import 'package:bicycle_project_app/model/mystation.dart';
import 'package:bicycle_project_app/model/weather_static.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/station_static.dart';

class Home2 extends StatefulWidget {
  const Home2({super.key});

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  late String temp; // 최저기온
  late String atemp; // 최고기온
  late String humidity; // 습도
  late String windspeed; // 풍속

  late List data;
  late List pbike;
  late bool checkValue;
  String result = 'all';
  // 계절
  late String season;
  int seasonNum = 0;
  // 계절

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

  // 대여소별 대여량
  late List clusterResult2384;
  late List clusterResult2342;
  late List clusterResult2301;
  late List clusterResult2348;

  @override
  void initState() {
    super.initState();
    temp = weatherStatic.TMN.toString();
    atemp = weatherStatic.TMX.toString();
    humidity = weatherStatic.REH.toString();
    windspeed = weatherStatic.WSD.toString();
    data = [];
    pbike = [];
    checkValue = false;
    // 현재 시간 가져오기
    _toDay = DateTime.now();
    month = '';

    // 계절
    if (_toDay.month.toString() == '1' ||
        _toDay.month.toString() == '2' ||
        _toDay.month.toString() == '12') {
      season = '1';
    } else if (_toDay.month.toString() == '3' ||
        _toDay.month.toString() == '4' ||
        _toDay.month.toString() == '5') {
      season = '2';
    } else if (_toDay.month.toString() == '6' ||
        _toDay.month.toString() == '7' ||
        _toDay.month.toString() == '8') {
      season = '3';
    } else {
      season = '4';
    }

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 11),
              child: Container(
                height: 100,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[200],
                  //그림자
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.7),
                  //     spreadRadius: 0,
                  //     blurRadius: 2.0,
                  //     offset: const Offset(0, 2),
                  //   ),
                  // ],
                ),
              ),
            ),
            Row(
              children: [
                Text(' 내 관할 대여소 목록'),
                Icon(Icons.arrow_drop_down),
                SizedBox(
                  width: 30,
                ),
                Text('공휴일'),
                Transform.scale(
                  scale: 1.0,
                  child: Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.black,
                    value: checkValue,
                    onChanged: (value) {
                      setState(() {
                        checkValue = value!;
                      });
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () {},
                    child: Text('조회하기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(118, 186, 153, 1),
                    ))
              ],
            ),
            //=============firebase 리스트 불러올 경우 =====================
            // Expanded(
            // child:
            // StreamBuilder<QuerySnapshot>(
            //   stream: FirebaseFirestore.instance
            //       .collection('mystation')
            //       .orderBy('snum', descending: false)
            //       .snapshots(),
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData) {
            //       return const Center(child: CupertinoActivityIndicator());
            //     }
            //     final documets = snapshot.data!.docs;
            //     //대여소별 리스트 ==============================================
            //     return ListView(
            //       children: documets.map((e) => _buildItemWidget(e)).toList(),
            //     );
            //   },
            // ),
            //

            //=============================유튜브 보고 만든거..
            Expanded(
              child: FutureBuilder(
                future: getJSONData(),
                builder: (context, snapshot) {
                  if (pbike.length != 0) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('mystation')
                          .snapshots(),
                      builder: (context, snapshot) {
                        return (snapshot.connectionState ==
                                ConnectionState.waiting)
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var data = snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;

                                  return _buildItemWidget(data, index);
                                },
                              );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            // ),

            //노가다 4개만들기
            // =====================그냥 4개 콘테이너 만들기 ===========<성공>
            // FutureBuilder(
            //   future: getJSONData(),
            //   builder: (context, snapshot) {
            //     if (pbike.length != 0) {
            //       return Padding(
            //         padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            //         child: Container(
            //           height: 85,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(20),
            //             color: Colors.grey[300],
            //           ),
            //           child: Row(
            //             children: [
            //               const SizedBox(
            //                 width: 10,
            //               ),
            //               Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Text(
            //                     '2301',
            //                     style: TextStyle(
            //                         fontSize: 22, fontWeight: FontWeight.bold),
            //                   ),
            //                   SizedBox(
            //                     height: 5,
            //                   ),
            //                   Text('현대고등학교입구'),
            //                 ],
            //               ),
            //               SizedBox(
            //                 width: 90,
            //               ),
            //               Text('현제 대수: ${pbike?[1]}\n예상 대여량: ??')
            //             ],
            //           ),
            //         ),
            //       );
            //     } else {
            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //   },
            // )
          ],
        ),
      ),
    );
  }

  //Widget
  Widget _buildItemWidget(doc, index) {
    final mystation = MyStation(
      sname: doc['sname'],
      snum: doc['snum'],
      sparkednum: doc['sparkednum'],
      sexpectednum: doc['sexpectednum'],
    );

    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete),
      ),
      key: ValueKey(doc),
      onDismissed: (direction) {
        // FirebaseFirestore.instance.collection('mystation').doc(doc.id).delete();
      },
      child: GestureDetector(
        onTap: () {
          Message.id = doc.id;
          Message.snum = doc['snum'];
          Message.sparkednum = doc['sparkednum'];
          Message.sexpectednum = doc['sexpectednum'];
          // Navigator.push(
          //   context,
          //    MaterialPageRoute(
          //     builder: (context) => const Update(),),);
        },
        // 대여소별 리스트 ==========================================
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Container(
            height: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[300],
            ),
            child: ListTile(
              title: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${mystation.snum}',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(mystation.sname),
                    ],
                  ),
                  SizedBox(
                    width: 90,
                  ),
                  Text(
                      '현제 대수: ${pbike[index]} \n예상 대여량: ${mystation.sexpectednum}')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Function ---
  Future<bool> getJSONData() async {
    var url = Uri.parse(
        'http://openapi.seoul.go.kr:8088/69614676726865733131375661556564/json/bikeList/1530/1610/');
    var response = await http.get(url);
    //print(response.body);
    var dateConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dateConvertedJSON['rentBikeStatus']['row'];
//2301. 현대고등학교 건너편 "stationId":"ST-777"
//2342. 대청역 1번출구  뒤 "stationId":"ST-823"
//2348. 포스코사거리(기업은행) "stationId":"ST-797"
//2384. 자곡사거리 "stationId":"ST-1364"
    //print("-----------------------------------------------------");
    for (int i = 0; i < result.length; i++) {
      //print(result[i]['stationId']);
      if (result[i]['stationId'] == "ST-777") {
        StationStatic.parking2301 = result[i]['parkingBikeTotCnt'];
        print(result[i]['stationName']);
      } else if (result[i]['stationId'] == "ST-823") {
        StationStatic.parking2342 = result[i]['parkingBikeTotCnt'];
        print(result[i]['stationName']);
      } else if (result[i]['stationId'] == "ST-797") {
        StationStatic.parking2348 = result[i]['parkingBikeTotCnt'];
        print(result[i]['stationName']);
      } else if (result[i]['stationId'] == "ST-1364") {
        StationStatic.parking2384 = result[i]['parkingBikeTotCnt'];
        print(result[i]['stationName']);
      }
    }
    pbike = [];
    pbike.add(StationStatic.parking2301);
    pbike.add(StationStatic.parking2342);
    pbike.add(StationStatic.parking2348);
    pbike.add(StationStatic.parking2384);
    print(pbike);
    return true;
  }

  // 화면실행시 자동실행되는 예측함수
  getJSONData2384() async {
    if (holiday == true) {
      // 공휴일을 숫자로 변경 후 jsp로 전달
      holidayNum = 0; // 공휴일
    } else {
      holidayNum = 1; // 비공휴일
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
    } else if (StationStatic.stationNum == 2384) {
      url = Uri.parse(
          'http://localhost:8080/RserveFlutter/prediction_bicycle_2384.jsp?temp=${temp}&atemp=${atemp}&humidity=${humidity}&windspeed=${windspeed}&season=$seasonNum&month=$month&holiday=$holidayNum');
    } else if (StationStatic.stationNum == 2342) {
      url = Uri.parse(
          'http://localhost:8080/RserveFlutter/prediction_bicycle_2342.jsp?temp=${temp}&atemp=${atemp}&humidity=${humidity}&windspeed=${windspeed}&season=$seasonNum&month=$month&holiday=$holidayNum');
    } else {
      url = Uri.parse(
          'http://localhost:8080/RserveFlutter/prediction_bicycle_2348.jsp?temp=${temp}&atemp=${atemp}&humidity=${humidity}&windspeed=${windspeed.text}&season=$seasonNum&month=$month&holiday=$holidayNum');
    }
    //2301=======================================

    url = Uri.parse(
        'http://localhost:8080/RserveFlutter/prediction_bicycle_2301.jsp?temp=${temp}&atemp=${atemp}&humidity=${humidity}&windspeed=${windspeed}&season=$seasonNum&month=$month&holiday=$holidayNum');

    var response = await http.get(url);

    setState(() {
      var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
      result = dataConvertedJSON['result'];
    });
    result = clusterResult2301[int.parse(result) - 1];

    //================================================================
    // 시용자가 선택한 대여소에 해당하는 대여량을 출력함
    if (StationStatic.stationNum == 2301) {
    } else if (StationStatic.stationNum == 2384) {
      result = clusterResult2384[int.parse(result) - 1];
    } else if (StationStatic.stationNum == 2342) {
      result = clusterResult2342[int.parse(result) - 1];
    } else {
      result = clusterResult2348[int.parse(result) - 1];
    }

    // _showDialog(context, result);
  }
} //end
