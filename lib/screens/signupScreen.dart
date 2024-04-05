import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController pwCheckController = TextEditingController();
  String selectedGender = "";

  bool isValidEmail(String email) {
    String pattern = r'^[\w-\.]+@([a-zA-Z\d-]+\.)+[a-zA-Z]{2,4}$';

    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  bool isValidPassword(String pw) {
    String pattern = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,20}$';

    RegExp regex = RegExp(pattern);
    return regex.hasMatch(pw);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text("SIGN UP", style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500),),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent.shade200,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(50),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: userController,
                    decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: '닉네임',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'example@xxx.com',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    controller: pwController,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: '8~20자 영문, 숫자, 특수문자 포함',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      controller: pwCheckController,
                      decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: '비밀번호를 한 번 더 입력해주세요',
                          prefixIcon: const Icon(Icons.check_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                      )
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("성별 (선택)", style: TextStyle(fontSize: 18)),
                        RadioMenuButton(
                            value: '남성',
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            },
                            child: const Text("남성", style: TextStyle(fontSize: 18))
                        ),
                        RadioMenuButton(
                            value: '여성',
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            },
                            child: const Text("여성", style: TextStyle(fontSize: 18))
                        )
                      ],
                    )
                  ),
                  const SizedBox(height: 90),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.white
                    ),
                    onPressed: () async{
                      if (userController.text.isEmpty) {
                        Fluttertoast.showToast(msg: "닉네임을 입력해주세요.");
                      }
                      else if (emailController.text.isEmpty) {
                        Fluttertoast.showToast(msg: "이메일을 입력해주세요.");
                      }
                      else if (pwController.text.isEmpty) {
                        Fluttertoast.showToast(msg: "비밀번호를 입력해주세요");
                      }
                      else if (pwCheckController.text.isEmpty) {
                        Fluttertoast.showToast(msg: "확인 비밀번호를 입력해주세요");
                      }
                      else if (!isValidEmail(emailController.text)) {
                        Fluttertoast.showToast(msg: "이메일 형식을 확인하세요.");
                      }
                      else if (!isValidPassword(pwController.text)) {
                        Fluttertoast.showToast(msg: "비밀번호 형식을 확인하세요");
                      }
                      else if (pwController.text.toString() != pwCheckController.text.toString()) {
                        Fluttertoast.showToast(msg: "Password가 일치하지 않습니다.");
                      }
                      else {
                        try {
                          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: pwController.text.toString()
                          );
                        }
                        on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            Fluttertoast.showToast(msg: "보안에 취약한 비밀번호입니다");
                          }
                          else if (e.code == 'email-already-in-use') {
                            Fluttertoast.showToast(msg: "이미 가입된 이메일입니다.");
                          }
                        }
                        catch (e) {
                          Fluttertoast.showToast(msg: "회원가입 성공");
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text("가입하기", style: TextStyle(fontSize: 18)),
                  ),

                  const SizedBox(height: 70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      const SizedBox(width: 50),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Back"),
                      ),
                    ],
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}
