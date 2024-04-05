import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:todo_list/screens/mainScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          title: const Text("LOGIN SCREEN", style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500),),
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent.shade200,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(50),
                child: Column(
                  children: [
                    const SizedBox(height: 130),
                    const Text("로그인 후", style: TextStyle(fontSize: 20),),
                    const SizedBox(height: 10),
                    const Text("나만의 TODO LIST를 만들어보세요", style: TextStyle(fontSize: 20),),
                    const SizedBox(height: 60),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: 'example@email.com',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                      )
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      controller: pwController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: '비밀번호 입력',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                      ),
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(60),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.white
                        ),
                        onPressed: () async{
                          //여기서 부터 다시 고민해보기 - 24.04.05
                          try {
                            UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: emailController.text.toString(),
                                password: pwController.text.toString()
                            );
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen()));
                          }
                          on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              Fluttertoast.showToast(msg: "등록되지 않은 이메일입니다");
                            }
                            else if (e.code == 'wrong-password') {
                              Fluttertoast.showToast(msg: "비밀번호를 확인하세요");
                            }
                          }
                          //await Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen()));
                          //Navigator.pop(context);
                        },
                        child: const Text("회원 로그인", style: TextStyle(fontSize: 18),)
                    ),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () async{
                              Fluttertoast.showToast(msg: "기억을 잘 끄집어 내보세요");
                            },
                            child: const Text("아이디 찾기")
                        ),
                        TextButton(
                            onPressed: () {
                              Fluttertoast.showToast(msg: "머리를 쥐어 짜 보아요");
                            },
                            child: const Text("비밀번호 찾기")
                        )
                      ],
                    )
                  ],
                )
            )
          ),
        )
    );
  }
}
