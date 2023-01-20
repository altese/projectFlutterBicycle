import 'package:bicycle_project_app/Model/userRegisterStatic.dart';
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

  late bool seePassword;
  late bool seeConfirmPassword;

  late List items; // 파이어베이스에서 가져온 데이터 담아둘 리스트

  late String idCheck; // ID 중복체크
  late String pwCheck; // PW 동일 여부 체크

  final FocusNode _idTextNode = FocusNode();
  final FocusNode _pwTextNode = FocusNode();
  final FocusNode _confirmPwTextNode = FocusNode();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    userNameController = TextEditingController();
    userPhoneController = TextEditingController();

    seePassword = true;
    seeConfirmPassword = true;

    items = [];

    idCheck = 'ID를 입력하세요.';
    pwCheck = '패스워드를 입력하세요.';
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

                  RawKeyboardListener(
                    focusNode: _idTextNode,
                    onKey: (value) {
                      getData();
                    },
                    child: MyTextfield(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      hintText: 'ID',
                      autofocus: true,
                      obscureText: false,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  idCheck == '사용 가능한 아이디 입니다.'
                      ? SizedBox(
                          width: 330,
                          child: Text(
                            idCheck,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 330,
                          child: Text(
                            idCheck,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                            ),
                          ),
                        ),

                  const SizedBox(
                    height: 10,
                  ),
                  //password textfield
                  RawKeyboardListener(
                    focusNode: _pwTextNode,
                    onKey: (value) {
                      checkedPassword();
                    },
                    child: MyTextfield(
                      controller: passwordController,
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
                  const SizedBox(
                    height: 10,
                  ),

                  //confirm password textfield
                  RawKeyboardListener(
                    focusNode: _confirmPwTextNode,
                    onKey: (value) {
                      checkedPassword();
                    },
                    child: MyTextfield(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      autofocus: false,
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
                          Icons.remove_red_eye,
                        ),
                        color: seeConfirmPassword == true
                            ? Colors.grey
                            : Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
                  const SizedBox(
                    height: 10,
                  ),

                  MyTextfield(
                    controller: userNameController,
                    hintText: 'Name',
                    autofocus: false,
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  MyTextfield(
                    controller: userPhoneController,
                    hintText: 'Phone',
                    autofocus: false,
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
                      signUserUp();
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
                          'Log In now',
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

  // --- Functions

  void signUserUp() async {
    //유저생성
    try {
      //비밀번호와 비밀번호 확인이 같은지 체크
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        registerNullCheck();
      } else {
        //에러메시지
        showErrorMessage('비밀번호가 일치하지 않습니다!');
      }

      // Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // 로딩화면끄기
      // Navigator.pop(context);

      // Wrong email
      if (e.code == 'user-not-found') {
        // 없는계정
        showErrorMessage('계정정보가 일치하지 않습니다');
      } else if (e.code == 'wrong-password') {
        // 비밀번호 틀림
        showErrorMessage('패스워드가 일치하지 않습니다');
      }
    }
    // await registerAction();
  }

  // --- Functions

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

  // 텍스트필드에 비어있는 값이 있는지 체크
  registerNullCheck() {
    if (emailController.text.isEmpty) {
      showSnackBar('아이디를 입력하세요.');
    } else if (passwordController.text.isEmpty) {
      showSnackBar('패스워드를 입력하세요.');
    } else if (confirmPasswordController.text.isEmpty) {
      showSnackBar('패스워드 확인을 입력하세요');
    } else if (userNameController.text.isEmpty) {
      showSnackBar('이름을 입력하세요.');
    } else if (userPhoneController.text.isEmpty) {
      showSnackBar('전화번호를 입력하세요.');
    } else {
      registerAction();
    }
  }

  // firebase database에 유저 정보 등록 (회원가입)
  registerAction() {
    if (userInfo.idCheck == 1 && userInfo.pwCheck == 1) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set(
        {
          'uId': emailController.text,
          'uPassword': passwordController.text,
          'uName': userNameController.text,
          'uPhone': userPhoneController.text
        },
      );
      // _showDialog(context);
    } else if (userInfo.idCheck == 0) {
      showSnackBar('중복 된 아이디 입니다.\n다른 아이디를 입력하세요.');
    } else {
      showSnackBar('패스워드가 일치하지 않습니다.\n패스워드를 동일하게 입력하세요.');
    }
  }

  showSnackBar(String result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
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
                // Navigator.pushNamed(context, '/loginPage');
                // Navigator.of(context).pop();
                // Navigator.pop(context);
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

// ID 중복체크
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
    });
    setState(() {
      if (items.isNotEmpty) {
        for (int i = 0; i < items.length; i++) {
          if (emailController.text == items[i]['uId']) {
            items.removeAt(0);
            idCheck = '중복 된 아이디 입니다.';
            userInfo.idCheck = 0;
          } else {
            idCheck = '사용 가능한 아이디 입니다.';
            userInfo.idCheck = 1;
          }
        }
      } else {
        idCheck = '사용 가능한 아이디 입니다.';
        userInfo.idCheck = 1;
      }

      if (emailController.text.isEmpty) {
        idCheck = 'ID를 입력하세요.';
        userInfo.idCheck = 0;
      }
    });
  }

  checkedPassword() {
    setState(() {
      if (passwordController.text != confirmPasswordController.text) {
        pwCheck = '패스워드가 일치하지 않습니다.';
        userInfo.pwCheck = 0;
      } else {
        pwCheck = '패스워드가 일치합니다.';
        userInfo.pwCheck = 1;
      }
      if (passwordController.text.isEmpty &&
          confirmPasswordController.text.isEmpty) {
        pwCheck = '패스워드를 입력하세요.';
        userInfo.pwCheck = 0;
      }
    });
  }

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
