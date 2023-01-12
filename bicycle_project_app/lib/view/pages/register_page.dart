import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../component/my_button.dart';
import '../component/my_textfield.dart';
import '../component/square_tile.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController userNameController;
  late TextEditingController userPhoneController;

  late List items;

  late String idCheck; // ID 중복체크
  late String userId;

  final FocusNode _textNode = FocusNode();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    userNameController = TextEditingController();
    userPhoneController = TextEditingController();

    items = [];

    idCheck = 'ID를 입력하세요.';
    userId = '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  const Icon(
                    Icons.lock,
                    size: 50,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    '지금 아이디를 만들어보세요!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: RawKeyboardListener(
                      focusNode: _textNode,
                      onKey: (value) {
                        // _fetch1();
                        userId = getData();
                      },
                      child: TextField(
                        // onChanged: (value) {
                        //   idcheck();
                        // },
                        controller: emailController,
                        obscureText: false,
                        decoration: InputDecoration(
                            //선택 비선택시 테두리색깔
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 110, 173, 143),
                              ),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintText: 'ID',
                            hintStyle: TextStyle(color: Colors.grey[500])),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // FutureBuilder(
                  //     future: _fetch1(),
                  //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //       //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                  //       if (snapshot.hasData == false) {
                  //         return const CircularProgressIndicator();
                  //       }
                  //       // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                  //       else {
                  //         return Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Text(
                  //             idCheck,
                  //             style: const TextStyle(fontSize: 15),
                  //           ),
                  //         );
                  //       }
                  //     }),
                  Text(userId),
                  const SizedBox(
                    height: 10,
                  ),
                  //password textfield
                  MyTextfield(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //confirm password textfield
                  MyTextfield(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  MyTextfield(
                    controller: userNameController,
                    hintText: 'Name',
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  MyTextfield(
                    controller: userPhoneController,
                    hintText: 'Phone',
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  const SizedBox(
                    height: 25,
                  ),
                  MyButton(
                    text: '회원가입',
                    onTap: () {
                      // signUserUp();
                      registerAction();
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SquareTile(imagePath: 'images/googlelogo.png'),
                      SizedBox(
                        width: 10,
                      ),
                      SquareTile(imagePath: 'images/kakao.png')
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),

                  //이미계정을 가지고있습니까?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '이미 계정을 가지고 있습니까?',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
//---function

  void signUserUp() async {
    //로딩화면
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    //유저생성
    try {
      //비밀번호와 비밀번호 확인이 같은지 체크
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      } else {
        //에러메시지
        showErrorMessage('비밀번호가 일치하지 않습니다!');
      }

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
//로딩화면끄기
      Navigator.pop(context);
      // Wrong email
      if (e.code == 'user-not-found') {
        //없는계정
        showErrorMessage('계정정보가 일치하지 않습니다');
      } else if (e.code == 'wrong-password') {
        //비밀번호 틀림
        showErrorMessage('계정정보가 일치하지 않습니다');
      }
    }
  }

  //function

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.pinkAccent,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // firebase database에 유저 정보 등록 (회원가입)
  registerAction() {
    FirebaseFirestore.instance.collection('user').add({
      'uId': emailController.text,
      'uPassword': passwordController.text,
      'uName': userNameController.text,
      'uPhone': userPhoneController.text
    });
    _showDialog(context);
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('회원가입'),
          content: const Text('회원가입이 완료 되었습니다.'),
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

  getData() async {
    var ID = '';
    setState(() {
      ID = emailController.text;
    });
    await FirebaseFirestore.instance
        .collection("user")
        .where('uId', isEqualTo: ID)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var i in snapshot.docs) {
        items.add(i.data());
      }
      // snapshot.docs.forEach(
      //   // add data to your list
      //   (f) => items.add(f.data()),
      // );
    });
    if (items.isNotEmpty) {
      print('userId : ' + items[0]['uId']);
      print(items.length);
      print(items);
      for (int i = 0; i < items.length; i++) {
        if (emailController.text == items[i]['uId']) {
          print('true : ' + emailController.text == items[i]['uId']);
          return '중복 된 아이디 입니다.';
        } else {
          print('false : ' + emailController.text == items[i]['uId']);
          return '사용 가능한 아이디 입니다.';
        }
      }
    }
    // return userId;
  }

  // Future<String> _fetch1() async {
  //   print('OK');
  //   userId = FirebaseFirestore.instance
  //       .collection('user')
  //       .where('uId', isEqualTo: 'user')
  //       .get()
  //       // .snapshots()
  //       .toString();
  //   print(userId);
  //   setState(() {
  //     print(emailController.text);
  //     if (userId == emailController.text) {
  //       idCheck = '중복 된 아이디 입니다.';
  //     } else if (userId != emailController.text) {
  //       idCheck = '사용 가능한 아이디 입니다.';
  //     }
  //   });
  //   return idCheck;
  // }

  // idcheck() {
  //   setState(() {
  //     userId = FirebaseFirestore.instance
  //         .collection('user')
  //         .where('uId', isEqualTo: emailController.text)
  //         .get()
  //         // .snapshots()
  //         .toString();

  //     _fetch1();

  //     setState(() {
  //       print(emailController.text);
  //       print(userId);
  //       print(userId == emailController.text);
  //     });
  //   });
  // }

  // void wrongPasswordMessage() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return const AlertDialog(
  //         backgroundColor: Colors.pinkAccent,
  //         title: Center(
  //             child: Text(
  //           'Incorrect Password',
  //           style: TextStyle(color: Colors.white),
  //         )),
  //       );
  //     },
  //   );
  // }
} //End
