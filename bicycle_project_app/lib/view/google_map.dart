import 'package:bicycle_project_app/Model/station_static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

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

  late List latitude;
  late List longitude;
  late List stationNum;
  late int selectedItem;
  late DateTime _toDay;

  late List _valueList;

  @override
  void initState() {
    super.initState();
    _markers = [];
    latitude = ['37.52407', '37.47603', '37.49401', '37.50723'];
    longitude = ['127.0218', '127.1059', '127.0795', '127.0569'];
    selectedItem = 0;

    _valueList = ['현대고등학교 건너편', '자곡 사거리', '대청역 1번출구 뒤', '포스코 사거리'];
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
            icon: const Icon(Icons.location_city_outlined),
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
                            '    거치대 수',
                            style: TextStyle(
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

  // getJSONData() async {
  //   var url1 = Uri.parse('http://localhost:8080/Rserve/latitude.jsp');
  //   var url2 = Uri.parse('http://localhost:8080/Rserve/longitude.jsp');
  //   var response1 = await http.get(url1);
  //   var response2 = await http.get(url2);

  //   latitude = response1.body;
  //   longitude = response2.body;
  // }
} // End
