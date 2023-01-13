import 'dart:convert';

import 'package:bicycle_project_app/model/message.dart';
import 'package:bicycle_project_app/view/component/chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../Model/rent.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  late String id;
  late String snum;
  late String sparkednum;
  late String sexpectednum;
  late String sname;
  static const LatLng _kMapCenter = LatLng(37.514575, 127.0495556);

  static const CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 16.0, tilt: 0, bearing: 0);

  late GoogleMapController _controller;

  void onMapCreated(GoogleMapController controller) async {
    _controller = controller;
  }

  late List<Marker> _markers;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 2, vsync: this);
    id = '';
    snum = Message.snum;
    sparkednum = Message.sparkednum;
    sexpectednum = Message.sexpectednum;
    sname = Message.sname;
    _markers = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 40,
        // 그림자
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    snum,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  sname,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 80,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[200],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Text(
                      '오늘 예상 총 대여량',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                    child: Text(
                      '32대',
                      style: TextStyle(fontSize: 27),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //===========================================
            Container(
              height: 80,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[200],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Text(
                      '현재 거치 수량',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                    child: Text(
                      '32대',
                      style: TextStyle(fontSize: 27),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //===============================================
            Container(
              height: 80,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[200],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Text(
                      '어제 대여량',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                    child: Text(
                      '32대',
                      style: TextStyle(fontSize: 27),
                    ),
                  )
                ],
              ),
            ),
            TabBar(
              controller: controller,
              tabs: const [
                Tab(
                  icon: Icon(
                    CupertinoIcons.chart_bar_alt_fill,
                    color: Color(0xff616161),
                  ),
                ),
                Tab(
                  icon: Icon(
                    CupertinoIcons.map_fill,
                    color: Color(0xff616161),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: controller,
                children: [
                  //=================================탭바의 차트
                  FutureBuilder(
                    future: getJSONData(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Chart(station: snum);
                      } else {
                        return const Center();
                      }
                    },
                  ),
                  //==================================탭바의 지도
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[200],
                    ),
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: GoogleMap(
                        initialCameraPosition: _kInitialPosition,
                        onMapCreated: onMapCreated,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        mapType: MapType.normal,
                        markers: Set.from(_markers),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> getJSONData() async {
    var url = Uri.parse('http://localhost:8080/Flutter/rent_select_query.jsp');
    var response = await http.get(url);

    Rent.rentCounts.clear();
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];

    // print('---------------------');
    // print('body: ${result}\n');
    // print('---------------------');
    // print('${result[0]['rcount']}');
    // setState(() {
    Rent.rentCounts.addAll(result);
    // Rent.fromMap(result);
    // });
    print('rcount: ${Rent.rentCounts[0]['rcount']}');
    return true;
  }
}
