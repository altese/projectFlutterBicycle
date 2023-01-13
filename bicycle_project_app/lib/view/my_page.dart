import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  List containers = ["정보 수정", "로그아웃", "탈퇴"];
  List icons = [Icons.person, Icons.logout, Icons.dangerous];
  List texts = ["정보 수정", "로그아웃", "탈퇴"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: containers.length,
        itemBuilder: (context, position) {
          return GestureDetector(
            onTap: () {
              switch (position) {
                // 정보수정 클릭
                case 0:
                  Navigator.pushNamed(context, '/userInfoUpdate');
                  break;
                // 로그아웃 클릭
                case 1:
                  _showDialogLogOut(context);
                  break;
                // 탈퇴 클릭
                case 2:
                  _showDialogWithdraw(context);
                  break;
                default:
                // 위의 값 A ~ E 모두 아닐때 실행할 명령문;
              }
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Icon(
                      icons[position],
                      size: 30,
                      color: const Color(0xff6B778D),
                    ),
                    const SizedBox(width: 8),
                    Text(texts[position],
                        style: const TextStyle(
                            color: Color(0xff525252), fontSize: 16)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

// 로그아웃 경고창
  _showDialogLogOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          content: const Text('정말 로그아웃 하시겠어요?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text(
                    '취소',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(ctx).pop();
                  },
                  child: const Text(
                    '확인',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

// 탈퇴 경고창
  _showDialogWithdraw(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          content: const Text('탈퇴를 진행할까요?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text(
                    '취소',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // FirebaseAuth.instance.currentUser?.delete();
                    // auth.currentUser?.delete();
                    await FirebaseAuth.instance.currentUser?.delete();
                    Navigator.pop(context);
                    _showDialogWithdrawCheck(context);
                  },
                  child: const Text(
                    '확인',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

// 탈퇴 확인 띄워주는 창
  _showDialogWithdrawCheck(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return const AlertDialog(
          content: Text('탈퇴가 완료되었습니다.'),
        );
      },
    );
  }
}
