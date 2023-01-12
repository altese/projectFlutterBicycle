import 'package:bicycle_project_app/model/message.dart';
import 'package:bicycle_project_app/model/mystation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home2 extends StatefulWidget {
  const Home2({super.key});

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
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
                height: 200,
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
              children: const [
                Text(' 내 관할 대여소 목록'),
                Icon(Icons.arrow_drop_down),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('mystation')
                    .orderBy('snum', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  final documets = snapshot.data!.docs;
                  //대여소별 리스트 ==============================================
                  return ListView(
                    children: documets.map((e) => _buildItemWidget(e)).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Widget
  Widget _buildItemWidget(DocumentSnapshot doc) {
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
                      '현재 대수: ${mystation.sparkednum} \n예상 대여량: ${mystation.sexpectednum}')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}//end
