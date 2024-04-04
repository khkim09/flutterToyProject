import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_list/screens/signupScreen.dart';
import 'loginScreen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text("LOGIN SCREEN", style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500),),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent.shade200,
      ),
      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              const SizedBox(height: 130),
              const Text("로그인 후", style: TextStyle(fontSize: 20),),
              const SizedBox(height: 10),
              const Text("나만의 TODO LIST를 만들어보세요", style: TextStyle(fontSize: 20),),
              const SizedBox(height: 60),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.white
                ),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                child: const Text("로그인", style: TextStyle(fontSize: 18),)
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.white
                ),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen())),
                child: const Text("회원가입", style: TextStyle(fontSize: 18))
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
      )
    );
  }
}
