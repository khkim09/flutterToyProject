import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../hive/todo_box.dart';
import 'mainScreen.dart';

class NewToDoScreen extends StatefulWidget {
  final Function() updateList;

  const NewToDoScreen({super.key, required this.updateList});

  @override
  State<NewToDoScreen> createState() => _NewToDoScreenState();
}

class _NewToDoScreenState extends State<NewToDoScreen> {
  String newText = "";
  DateTime startDate = DateTime.now();
  DateTime finishDate = DateTime.now();
  DateTime startTime = DateTime.now();
  DateTime finishTime = DateTime.now();
  String newMemo = "";

  TextEditingController textController = TextEditingController(); //controller: TextEditingController - textfield 입력 값 접근 위한 변수
  TextEditingController memoController = TextEditingController();

  save() {
    if (newText == "") {
      return showDialog(context: context, builder: (context) =>
          AlertDialog(
            title: const Text("잠깐!!!", style: TextStyle(fontSize: 25),),
            content: const Text("할 일을 작성해주세요!"),
            actions: <Widget>[
              TextButton(
                  child: const Text("작성하기", style: TextStyle(color: Colors.deepPurpleAccent),),
                  onPressed: () {
                    Navigator.pop(context);
                    FocusScope.of(context).unfocus();
                  }
              )
            ],
          ),
      );
    }
    else if (startDate.difference(finishDate).inDays > 0) {
      return showDialog(context: context, builder: (BuildContext context) =>
          AlertDialog(
            title: const Text("잠깐!!!", style: TextStyle(fontSize: 25),),
            content: const Text("날짜를 확인하세요!"),//const Text("시작일과 종료일을 확인해주세요!"),
            actions: <Widget>[
              TextButton(
                child: const Text("시간 수정", style: TextStyle(color: Colors.deepPurpleAccent),),
                onPressed: () {
                  Navigator.pop(context);
                  FocusScope.of(context).unfocus();
                },
              )
            ],
          )
      );
    }
    else if (startDate.difference(finishDate).inDays == 0  && startTime.difference(finishTime).inMinutes > 0) {
      return showDialog(context: context, builder: (BuildContext context) =>
          AlertDialog(
            title: const Text("잠깐!!!", style: TextStyle(fontSize: 25),),
            content: const Text("시간을 확인하세요!"),//const Text("시작일과 종료일을 확인해주세요!"),
            actions: <Widget>[
              TextButton(
                child: const Text("시간 수정", style: TextStyle(color: Colors.deepPurpleAccent),),
                onPressed: () {
                  Navigator.pop(context);
                  FocusScope.of(context).unfocus();
                },
              )
            ],
          )
      );
    }
    else {
      var newTodo = TodoBox()
        ..text = newText
        ..startDate = startDate
        ..finishDate = finishDate
        ..startTime = startTime
        ..finishTime = finishTime
        ..memo = newMemo;

      Hive.box<TodoBox>('myBox').add(newTodo);
      widget.updateList();

      Navigator.of(context).pop(MaterialPageRoute(builder: (BuildContext context) => const MainScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber.shade100,
        appBar: AppBar(
          backgroundColor: Colors.amber.shade100,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(MaterialPageRoute(builder: (BuildContext context) => const MainScreen())), //navigator 기본 제공 뒤로 가기 버튼 -> 아이콘 수정 위해 leading 작성
            icon: const Text("취소", style: TextStyle(fontSize: 18),),
          ),
          title: const Text("오늘의 할 일이 무엇인가요?", style: TextStyle(fontSize: 22),),
          actions: [
            IconButton(
                onPressed: () => save(), //save 구현 및 mainscreen으로 복귀 구현
                icon: const Text("완료", style: TextStyle(fontSize: 18),)
            )
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                children: [
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("할 일", style: TextStyle(fontSize: 20),),
                          TextField(
                            controller: textController, //textfield의 변환된 값 접근을 위한 장치
                            onChanged: (string) {//입력 완료 시 check 함수 호출
                              newText = string;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30,),

                  Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("시간 설정", style: TextStyle(fontSize: 20),),
                            const SizedBox(height: 30,),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("시작일", style: TextStyle(fontSize: 16),),
                                    const SizedBox(width: 30),
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      alignment: Alignment.center,
                                      child: TextButton(
                                        child: Text("${startDate.year}.${startDate.month}.${startDate.day}", style: const TextStyle(fontSize: 20, color: Colors.black),),
                                        onPressed: () async{
                                          await showDatePicker(
                                            context: context,
                                            firstDate: DateTime(2024),
                                            lastDate: DateTime(2025),
                                          ).then((date) => setState(() {
                                            startDate = date!;
                                          }));
                                        },
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                          alignment: Alignment.center,
                                          child: TextButton(
                                              onPressed: () async{
                                                await showModalBottomSheet(
                                                    context: context,
                                                    builder: (BuildContext context) =>
                                                        Container(
                                                            color: Colors.white,
                                                            height: MediaQuery.of(context).size.height * 0.3,
                                                            child: CupertinoDatePicker(
                                                              backgroundColor: Colors.white,
                                                              initialDateTime: startTime,
                                                              use24hFormat: false,
                                                              mode: CupertinoDatePickerMode.time,
                                                              onDateTimeChanged: (DateTime newTime) {
                                                                setState(() {
                                                                  startTime = newTime;
                                                                });
                                                              },
                                                            )
                                                        )
                                                );
                                              },
                                              child: Text(DateFormat("HH : mm").format(startTime), style: const TextStyle(fontSize: 20, color: Colors.black),)
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30,),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("종료일", style: TextStyle(fontSize: 16),),
                                    const SizedBox(width: 30),
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      alignment: Alignment.center,
                                      child: TextButton(
                                        child: Text("${finishDate.year}.${finishDate.month}.${finishDate.day}", style: const TextStyle(fontSize: 20, color: Colors.black),),
                                        onPressed: () async{
                                          await showDatePicker(
                                            context: context,
                                            firstDate: DateTime(2024),
                                            lastDate: DateTime(2025),
                                          ).then((date) => setState(() {
                                            finishDate = date!;
                                          }));
                                        },
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                          alignment: Alignment.center,
                                          child: TextButton(
                                              onPressed: () async{
                                                await showModalBottomSheet(
                                                    context: context,
                                                    builder: (BuildContext context) =>
                                                        Container(
                                                            color: Colors.white,
                                                            height: MediaQuery.of(context).size.height * 0.3,
                                                            child: CupertinoDatePicker(
                                                              backgroundColor: Colors.white,
                                                              initialDateTime: DateTime.now(),
                                                              use24hFormat: false,
                                                              mode: CupertinoDatePickerMode.time,
                                                              onDateTimeChanged: (DateTime newTime) {
                                                                setState(() {
                                                                  finishTime = newTime;
                                                                });
                                                              },
                                                            )
                                                        )
                                                );
                                              },
                                              child: Text(DateFormat("HH : mm").format(finishTime), style: const TextStyle(fontSize: 20, color: Colors.black),)
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]
                  ),

                  const SizedBox(height: 50,),

                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("메 모", style: TextStyle(fontSize: 20),),
                          const SizedBox(height: 20,),
                          TextField(
                            textAlignVertical: TextAlignVertical.top,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 120)
                            ),
                            controller: memoController,
                            onChanged: (string) {
                              newMemo = string;
                            },
                          )
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        )
    );
  }
}