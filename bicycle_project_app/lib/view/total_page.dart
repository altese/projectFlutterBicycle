import 'dart:convert';
import 'package:bicycle_project_app/Model/message.dart';
import 'package:bicycle_project_app/Model/mystation.dart';
import 'package:bicycle_project_app/view/pages/detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/station_static.dart';
import '../Model/weather_static.dart';

class TotalPage extends StatefulWidget {
  const TotalPage({super.key});

  @override
  State<TotalPage> createState() => _TotalPageState();
}

class _TotalPageState extends State<TotalPage> {
  String name = '';
  late TextEditingController searchTf;
  late String temp; // 최저기온
  late String atemp; // 최고기온
  late String humidity; // 습도
  late String windspeed; // 풍속

  late String total;
  List<Color> colorlist = [
    const Color.fromRGBO(234, 250, 209, 1),
    const Color.fromRGBO(181, 226, 218, 1),
    const Color.fromRGBO(147, 197, 243, 1),
    const Color.fromRGBO(160, 164, 253, 1),
  ];

  late List data;
  late List pbike;
  late Map pResult;

  // 테스트
  late String r2301;
  late String r2342;
  late String r2348;
  late String r2384;

  late List pResult2;
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
    total = '';
    searchTf = TextEditingController();
    temp = WeatherStatic.TMN.toString();
    atemp = WeatherStatic.TMX.toString();
    humidity = WeatherStatic.REH.toString();
    windspeed = WeatherStatic.WSD.toString();
    print(temp);
    print(atemp);
    print(humidity);
    print(windspeed);
    data = [];
    pbike = [];
    pResult2 = [];
    pResult = {};
    checkValue = false;
    // 현재 시간 가져오기
    _toDay = DateTime.now();
    month = _toDay.month.toString();

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

    // getJSONData2301();
    // getJSONData2342();
    // getJSONData2348();
    // getJSONData2384();

    // calc();

    totalSum();
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
              child: GestureDetector(
                onTap: () {
                  // calc();
                },
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '예상 총 대여량',
                        style: TextStyle(
                          fontSize: 23,
                          color: Color.fromARGB(255, 91, 91, 91),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Text(
                        total,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            TextField(
              controller: searchTf,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search), hintText: '검색..'),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(' 내 관할 대여소 목록'),
                // Icon(Icons.arrow_drop_down),
                const SizedBox(width: 30),
                const Text('공휴일'),
                Transform.scale(
                  scale: 1.0,
                  child: Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.black,
                    value: holiday,
                    onChanged: (value) {
                      setState(() {
                        holiday = value!;
                      });
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // setState(() {
                    getJSONData2301();
                    getJSONData2342();
                    getJSONData2348();
                    getJSONData2384();
                    calc();
                    // });
                    setState(() {});
                    print(pResult);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(118, 186, 153, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  child: const Text('조회하기'),
                ),
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
                  if (pbike.isNotEmpty) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('mystation')
                          .snapshots(),
                      builder: (context, snapshot) {
                        return (snapshot.connectionState ==
                                ConnectionState.waiting)
                            ? const Center(
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
                    return const Center(child: CircularProgressIndicator());
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
    if (name.isEmpty) {
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
            Message.sname = doc['sname'];
            Message.snum = doc['snum'];
            Message.sparkednum = doc['sparkednum'];
            Message.sexpectednum = doc['sexpectednum'];
            Message.pbike = pbike[index];
            Message.presult = pResult[index];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DetailPage(),
              ),
            );
          },
          // 대여소별 리스트 ==========================================
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Container(
              height: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorlist[index],
              ),
              child: ListTile(
                title: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mystation.snum,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 5),
                          Text(mystation.sname),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                        '현재 거치 수량: ${pbike[index]} \n예상 대여량: ${pResult[index]}')
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (doc['sname'].toString().contains(name.toLowerCase())) {
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
            Message.sname = doc['sname'];
            Message.snum = doc['snum'];
            Message.sparkednum = doc['sparkednum'];
            Message.sexpectednum = doc['sexpectednum'];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DetailPage(),
              ),
            );
          },
          // 대여소별 리스트 ==========================================
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Container(
              height: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorlist[index],
              ),
              child: ListTile(
                title: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mystation.snum,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 5),
                          Text(mystation.sname),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text('현재 대수: ${pbike[index]} \n예상 대여량: ${pResult[index]}')
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Container();
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
        // print(result[i]['stationName']);
      } else if (result[i]['stationId'] == "ST-823") {
        StationStatic.parking2342 = result[i]['parkingBikeTotCnt'];
        // print(result[i]['stationName']);
      } else if (result[i]['stationId'] == "ST-797") {
        StationStatic.parking2348 = result[i]['parkingBikeTotCnt'];
        // print(result[i]['stationName']);
      } else if (result[i]['stationId'] == "ST-1364") {
        StationStatic.parking2384 = result[i]['parkingBikeTotCnt'];
        // print(result[i]['stationName']);
      }
    }
    pbike = [];
    pbike.add(StationStatic.parking2301);
    pbike.add(StationStatic.parking2342);
    pbike.add(StationStatic.parking2348);
    pbike.add(StationStatic.parking2384);
    // print(pbike);
    return true;
  }

  // 화면실행시 자동실행되는 예측함수
  getJSONData2301() async {
    if (holiday == true) {
      // 공휴일을 숫자로 변경 후 jsp로 전달
      holidayNum = 0; // 공휴일
    } else {
      holidayNum = 1; // 비공휴일
    }
    // print('holiday2301:$holidayNum');
    // 날짜를 숫자로 변경 후 jsp로 전달

    Uri url;

    //2301=======================================

    url = Uri.parse(
        'http://localhost:8080/RserveFlutter/prediction_bicycle_2301.jsp?temp=$temp&atemp=$atemp&humidity=$humidity&windspeed=$windspeed&season=$seasonNum&month=$month&holiday=$holidayNum');

    var response = await http.get(url);

    // setState(() {
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    result = dataConvertedJSON['result'];
    // });
    result = clusterResult2301[int.parse(result) - 1];

    // setState(() {
    pResult[0] = result;
    // });
    //================================================================
    // 시용자가 선택한 대여소에 해당하는 대여량을 출력함
    print('2301:::::::::${pResult[0]}');
    // _showDialog(context, result);
  }

  getJSONData2342() async {
    if (holiday == true) {
      // 공휴일을 숫자로 변경 후 jsp로 전달
      holidayNum = 0; // 공휴일
    } else {
      holidayNum = 1; // 비공휴일
    }
    print('holiday2342:$holidayNum');
    // 날짜를 숫자로 변경 후 jsp로 전달

    var url;

    url = Uri.parse(
        'http://localhost:8080/RserveFlutter/prediction_bicycle_2342.jsp?temp=$temp&atemp=$atemp&humidity=$humidity&windspeed=$windspeed&season=$seasonNum&month=$month&holiday=$holidayNum');

    var response = await http.get(url);

    setState(() {
      var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
      result = dataConvertedJSON['result'];
    });
    result = clusterResult2342[int.parse(result) - 1];

    // setState(() {
    pResult[1] = result;
    // });
    print('2342:::::::::${pResult[1]}');
    //================================================================
    // 시용자가 선택한 대여소에 해당하는 대여량을 출력함

    // _showDialog(context, result);
  }

  getJSONData2348() async {
    if (holiday == true) {
      // 공휴일을 숫자로 변경 후 jsp로 전달
      holidayNum = 0; // 공휴일
    } else {
      holidayNum = 1; // 비공휴일
    }
    print('holiday2348:$holidayNum');
    // 날짜를 숫자로 변경 후 jsp로 전달

    var url;

    url = Uri.parse(
        'http://localhost:8080/RserveFlutter/prediction_bicycle_2348.jsp?temp=$temp&atemp=$atemp&humidity=$humidity&windspeed=$windspeed&season=$seasonNum&month=$month&holiday=$holidayNum');

    var response = await http.get(url);

    // setState(() {
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    result = dataConvertedJSON['result'];
    // });
    result = clusterResult2348[int.parse(result) - 1];
    // setState(() {
    pResult[2] = result;
    // });
    print('2348:::::::::${pResult[2]}');
    //================================================================
    // 시용자가 선택한 대여소에 해당하는 대여량을 출력함

    // _showDialog(context, result);
  }

  getJSONData2384() async {
    if (holiday == true) {
      // 공휴일을 숫자로 변경 후 jsp로 전달
      holidayNum = 1; // 공휴일
    } else {
      holidayNum = 0; // 비공휴일
    }
    print('holiday2384:$holidayNum');
    // 날짜를 숫자로 변경 후 jsp로 전달

    var url;

    url = Uri.parse(
        'http://localhost:8080/RserveFlutter/prediction_bicycle_2384.jsp?temp=$temp&atemp=$atemp&humidity=$humidity&windspeed=$windspeed&season=$seasonNum&month=$month&holiday=$holidayNum');

    var response = await http.get(url);

    // setState(() {
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    result = dataConvertedJSON['result'];
    // });
    result = clusterResult2384[int.parse(result) - 1];
    // setState(() {
    pResult[3] = result;
    // });
    print('2384:::::::::${pResult[3]}');
    //================================================================
    // 시용자가 선택한 대여소에 해당하는 대여량을 출력함

    // _showDialog(context, result);
  }

  calc() {
    // setState(() {
    total =
        "${int.parse(pResult[0].toString().substring(0, 3)) + int.parse(pResult[1].toString().substring(0, 3)) + int.parse(pResult[2].toString().substring(0, 3)) + int.parse(pResult[3].toString().substring(0, 3))}~${int.parse(pResult[0].toString().substring(5, 7)) + int.parse(pResult[1].toString().substring(5, 7)) + int.parse(pResult[2].toString().substring(5, 7)) + int.parse(pResult[3].toString().substring(5, 7))}";
    // });
  }

  Future totalSum() async {
    await getJSONData2301();
    await getJSONData2342();
    await getJSONData2348();
    await getJSONData2384();

    calc();
    setState(() {});
  }
} //end
