import 'dart:convert';

import 'package:bicycle_project_app/Model/station_static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SimpleMap extends StatefulWidget {
  const SimpleMap({super.key});

  @override
  State<SimpleMap> createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMap> {
  static const LatLng _kMapCenter = LatLng(37.514575, 127.0495556);

  static const CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 16.0, tilt: 0, bearing: 0);

  late GoogleMapController _controller;

  void onMapCreated(GoogleMapController controller) async {
    _controller = controller;
  }

  late List<Marker> _markers;
  String result = 'all';

  late List data; // 대여소별 따릉이 거치수 api

  late List latitude;
  late List longitude;
  late List stationNum;
  late int selectedItem;
  late DateTime _toDay;

  late List _valueList;

  @override
  void initState() {
    super.initState();

    // 대여소별 따릉이 거치수 api
    data = [];
    getJSONData();

    _markers = [];
    latitude = ['37.52407', '37.47603', '37.49401', '37.50723'];
    longitude = ['127.0218', '127.1059', '127.0795', '127.0569'];
    selectedItem = 0;

    _valueList = ['현대고등학교 건너편', '자곡 사거리', '대청역 1번출구 뒤', '포스코 사거리(기업은행)'];
    stationNum = ['2301', '2384', '2342', '2348'];

    _toDay = DateTime.now();

    // getJSONData();

    // for (int i = 0; i <= latitude.length; i++) {
    //   _markers.add(Marker(
    //       markerId: const MarkerId("1"),
    //       draggable: true,
    //       onTap: () => print("Marker!"),
    //       position: LatLng(latitude[i], 127.0495556)));

    _markers.add(Marker(
        markerId: const MarkerId("1"),
        draggable: true,
        onTap: () => print("Marker!"),
        position: const LatLng(37.514575, 127.0495556)));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: GoogleMap(
            initialCameraPosition: _kInitialPosition,
            onMapCreated: onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            markers: Set.from(_markers),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 60, right: 10),
          alignment: Alignment.topRight,
          child: FloatingActionButton.extended(
            onPressed: () {
              // getJSONData();
              // test();
              Get.bottomSheet(
                Container(
                  height: 250,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 110,
                        child: CupertinoPicker(
                          itemExtent: 30,
                          scrollController:
                              FixedExtentScrollController(initialItem: 0),
                          onSelectedItemChanged: (value) {
                            setState(() {
                              selectedItem = value;
                            });
                          },
                          children: [
                            Text(
                              _valueList[0],
                            ),
                            Text(
                              _valueList[1],
                            ),
                            Text(
                              _valueList[2],
                            ),
                            Text(
                              _valueList[3],
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          StationStatic.stationNum =
                              int.parse(stationNum[selectedItem]);
                          clickButton();
                        },
                        child: const Text(
                          'OK',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            label: const Text('대여소'),
            icon: const Icon(Icons.bike_scooter),
            elevation: 8,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 770, right: 10),
          alignment: Alignment.topRight,
          child: FloatingActionButton(
            onPressed: () async {
              var gps = await getCurrentLocation();

              _controller.animateCamera(
                  CameraUpdate.newLatLng(LatLng(gps.latitude, gps.longitude)));
            },
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.my_location,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ));
  }

  // --- functions

  // 내 위치정보 가져오기
  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    print(position.longitude);
    return position;
  }

  clickButton() {
    _controller.animateCamera(CameraUpdate.newLatLng(LatLng(
        double.parse(latitude[selectedItem]),
        double.parse(longitude[selectedItem]))));
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId("1"),
          draggable: true,
          onTap: () {
            Get.bottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              Container(
                  height: 130,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            '    ${_valueList[selectedItem]}',
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const Text(
                            '    거치대수 : ',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            StationStatic.stationNum == 2301
                                ? StationStatic.parking2301
                                : StationStatic.stationNum == 2348
                                    ? StationStatic.parking2348
                                    : StationStatic.stationNum == 2384
                                        ? StationStatic.parking2384
                                        : StationStatic.parking2342,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            '    대여소 번호 : ${stationNum[selectedItem]}',
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/station');
                              StationStatic.stationNum =
                                  int.parse(stationNum[selectedItem]);
                            },
                            child: const Text(
                              '예측하러가기',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(_toDay.toString().substring(0, 19)),
                    ],
                  )),
            );
          },
          infoWindow: InfoWindow(
            title: _valueList[selectedItem],
          ),
          position: LatLng(
            double.parse(latitude[selectedItem]),
            double.parse(
              longitude[selectedItem],
            ),
          ),
        ),
      );
    });

    navigator!.pop();
  }

  // --- Function ---
  // Future<bool> getJSONData() async {
  //   var url = Uri.parse(
  //       'http://openapi.seoul.go.kr:8088/69614676726865733131375661556564/json/bikeList/1536/1606/');
  //   var response = await http.get(url);
  //   var dateConvertedJSON = json.decode(utf8.decode(response.bodyBytes));

  //   List result = dateConvertedJSON['rentBikeStatus']['row'];

  //   setState(() {
  //     data.addAll(result);
  //   });
  //   StationStatic.parking2301 = data[0]['parkingBikeTotCnt'];
  //   StationStatic.parking2342 = data[38]['parkingBikeTotCnt'];
  //   StationStatic.parking2348 = data[42]['parkingBikeTotCnt'];
  //   StationStatic.parking2384 = data[70]['parkingBikeTotCnt'];

  //   print("——————————————————————————");
  //   print(data[0]['stationName']);
  //   print("ParkingBiketoCount : " + data[0]['parkingBikeTotCnt']);
  //   print(StationStatic.parking2301);
  //   print(data[38]['stationName']);
  //   print("ParkingBiketoCount : " + data[38]['parkingBikeTotCnt']);
  //   print(StationStatic.parking2342);
  //   print(data[42]['stationName']);
  //   print("ParkingBiketoCount : " + data[42]['parkingBikeTotCnt']);
  //   print(StationStatic.parking2348);
  //   print(data[70]['stationName']);
  //   print("ParkingBiketoCount : " + data[70]['parkingBikeTotCnt']);
  //   print(StationStatic.parking2384);
  //   return true;

  //   return true;
  // }
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
    return true;
  }

  // getJSONData() async {
  //   var url1 = Uri.parse('http://localhost:8080/Rserve/latitude.jsp');
  //   var url2 = Uri.parse('http://localhost:8080/Rserve/longitude.jsp');
  //   var response1 = await http.get(url1);
  //   var response2 = await http.get(url2);

  //   latitude = response1.body;
  //   longitude = response2.body;
  // }
} // End
