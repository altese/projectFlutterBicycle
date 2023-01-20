import 'package:bicycle_project_app/Model/userRegisterStatic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../component/my_textfield.dart';

class UserInfoUpdate extends StatefulWidget {
  const UserInfoUpdate({super.key});

  @override
  State<UserInfoUpdate> createState() => _UserInfoUpdateState();
}

class _UserInfoUpdateState extends State<UserInfoUpdate> {
  late TextEditingController idController;
  late TextEditingController pwController;
  late TextEditingController confirmPwController;
  late TextEditingController nameController;
  late TextEditingController phoneController;

  late String pwCheck; // PW 동일 여부 체크

  late bool seePassword;
  late bool seeConfirmPassword;

  final FocusNode _pwTextNode = FocusNode();
  final FocusNode _confirmPwTextNode = FocusNode();

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    pwController = TextEditingController();
    confirmPwController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();

    pwCheck = '패스워드를 입력하세요.';

    idController.text = userInfo.userId;
    nameController.text = userInfo.userName;
    phoneController.text = userInfo.userPhone;

    seePassword = true;
    seeConfirmPassword = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            MyTextfield(
              controller: idController,
              hintText: 'ID',
              autofocus: true,
              obscureText: false,
            ),
            RawKeyboardListener(
              focusNode: _pwTextNode,
              onKey: (value) {
                checkedPassword();
              },
              child: MyTextfield(
                controller: pwController,
                hintText: 'Password',
                autofocus: false,
                obscureText: seePassword,
                icon: IconButton(
                  onPressed: () {
                    setState(() {
                      seePassword == true
                          ? seePassword = false
                          : seePassword = true;
                    });
                  },
                  icon: const Icon(
                    Icons.remove_red_eye_rounded,
                  ),
                  color: seePassword == true ? Colors.grey : Colors.blue,
                ),
              ),
            ),
            RawKeyboardListener(
              focusNode: _confirmPwTextNode,
              onKey: (value) {
                checkedPassword();
              },
              child: MyTextfield(
                controller: confirmPwController,
                hintText: 'Confirm Password',
                autofocus: true,
                obscureText: seeConfirmPassword,
                icon: IconButton(
                  onPressed: () {
                    setState(() {
                      seeConfirmPassword == true
                          ? seeConfirmPassword = false
                          : seeConfirmPassword = true;
                    });
                  },
                  icon: const Icon(
                    Icons.remove_red_eye_rounded,
                  ),
                  color: seeConfirmPassword == true ? Colors.grey : Colors.blue,
                ),
              ),
            ),
            pwCheck == '패스워드가 일치합니다.'
                ? SizedBox(
                    width: 330,
                    child: Text(
                      pwCheck,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.blue,
                      ),
                    ),
                  )
                : SizedBox(
                    width: 330,
                    child: Text(
                      pwCheck,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.red,
                      ),
                    ),
                  ),
            MyTextfield(
              controller: nameController,
              hintText: 'Name',
              autofocus: false,
              obscureText: false,
            ),
            MyTextfield(
              keyboardType: TextInputType.number,
              controller: phoneController,
              hintText: 'Phone',
              autofocus: false,
              obscureText: false,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if (userInfo.pwCheck == 1) {
                  String id = idController.text;
                  String pw = pwController.text;
                  String name = nameController.text;
                  String phone = phoneController.text;
                  updateAction(id, pw, name, phone);
                } else {
                  errorDialog();
                }
              },
              child: const Text(
                '수정',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Functions
  updateAction(String id, String pw, String name, String phone) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(userInfo.docId)
        .update({'uId': id, 'uPw': pw, 'uName': name, 'uPhone': phone});
    _showDialog(context);
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('수정 결과'),
          content: const Text('수정이 완료 되었습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
              ),
            ),
          ],
        );
      },
    );
  }

  checkedPassword() {
    setState(() {
      if (pwController.text != confirmPwController.text) {
        pwCheck = '패스워드가 일치하지 않습니다.';
        userInfo.pwCheck = 0;
      } else {
        pwCheck = '패스워드가 일치합니다.';
        userInfo.pwCheck = 1;
      }
      if (pwController.text.isEmpty && confirmPwController.text.isEmpty) {
        pwCheck = '패스워드를 입력하세요.';
        userInfo.pwCheck = 0;
      }
    });
  }

  errorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('패스워드가 동일한지 확인하세요.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
              ),
            ),
          ],
        );
      },
    );
  }
} // End
