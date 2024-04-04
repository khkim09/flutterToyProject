import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../hive/todo_box.dart';
import 'newTodoScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var todoList = Hive.box<TodoBox>('myBox').values.toList().cast<TodoBox>();

  onTapNewToDo() { //추가는 newtodoscreen에 callback 함수(updateList) 생성해서 즉시 적용되도록 구현(updateTodoList)
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewToDoScreen(updateList: updateTodoList,)));
  }

  void updateTodoList() {
    setState(() {
      todoList = Hive.box<TodoBox>('myBox').values.toList().cast<TodoBox>();
    });
    todoList.sort((a,b) => a.startDate.compareTo(b.startDate)); //시작 시간 순 정렬
  }

  void deleteTodoIndex(int index) { //삭제는 delete 아이콘 onPressed 시 setState로 todoList에서 지워주고 hive에서 지워주기
    setState(() {
      todoList.removeAt(index);
    });
    Hive.box<TodoBox>('myBox').deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade100,
      appBar: AppBar(
        backgroundColor: Colors.amber.shade100,
        toolbarHeight: 100,
        leading: const Placeholder(),
        leadingWidth: 0,
        title: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_outlined, size: 25,),
                SizedBox(width: 10),
                Text("ToDoList", style: TextStyle(fontSize: 25),)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: onTapNewToDo, icon: const Icon(Icons.add, size: 30,))
              ],
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ExpansionTile(
                title: const Text("오늘의 할 일", style: TextStyle(fontSize: 20)),
                children: [
                  Builder(
                      builder: (context) {
                        final todayTodoList = todoList.where((todo) => todo.startDate.day == DateTime.now().day);
                        if (todayTodoList.isEmpty) {
                          return const Center(child: Text("할 일을 작성해주세요!", style: TextStyle(fontSize: 18),));
                        }
                        else {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: todayTodoList.length,
                              itemBuilder: (context, index) {
                                var todo = todayTodoList.elementAt(index);
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(40, 0, 20, 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${todo.text} / ${DateFormat('yyyy-MM-dd').format(todo.startDate)} ~ ${DateFormat('yyyy-MM-dd').format(todo.finishDate)}', style: const TextStyle(fontSize: 18),),
                                      IconButton(onPressed: () => deleteTodoIndex(index), icon: const Icon(Icons.delete), iconSize: 18,)
                                    ],
                                  ),
                                );
                              }
                          );
                        }
                      }
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              ExpansionTile(
                title: const Text("일주일 간 해야할 일", style: TextStyle(fontSize: 20)),
                children: [
                  Builder(
                      builder: (context) {
                        final weekTodoList = todoList.where((todo) => 0 <= todo.startDate.difference(DateTime.now()).inDays
                            && todo.startDate.difference(DateTime.now()).inDays <= 7);
                        if (weekTodoList.isEmpty) {
                          return const Center(child: Text("할 일을 작성해주세요!", style: TextStyle(fontSize: 18),));
                        }
                        else {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: weekTodoList.length,
                              itemBuilder: (context, index) {
                                var todo = weekTodoList.elementAt(index);
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(40, 0, 20, 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${todo.text} / ${DateFormat('yyyy-MM-dd').format(todo.startDate)} ~ ${DateFormat('yyyy-MM-dd').format(todo.finishDate)}', style: const TextStyle(fontSize: 18),),
                                      IconButton(onPressed: () => deleteTodoIndex(index), icon: const Icon(Icons.delete), iconSize: 18,)
                                    ],
                                  ),
                                );
                              }
                          );
                        }
                      }
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              ExpansionTile(
                title: const Text("이번 달의 할 일", style: TextStyle(fontSize: 20)),
                children: [
                  Builder(
                      builder: (context) {
                        final monthTodoList = todoList.where((todo) => todo.startDate.month == DateTime.now().month);
                        if (monthTodoList.isEmpty) {
                          return const Center(child: Text("할 일을 작성해주세요!", style: TextStyle(fontSize: 18),));
                        }
                        else {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: monthTodoList.length,
                              itemBuilder: (context, index) {
                                var todo = monthTodoList.elementAt(index);
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(40, 0, 20, 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${todo.text} / ${DateFormat('yyyy-MM-dd').format(todo.startDate)} ~ ${DateFormat('yyyy-MM-dd').format(todo.finishDate)}', style: const TextStyle(fontSize: 18),),
                                      IconButton(onPressed: () => deleteTodoIndex(index), icon: const Icon(Icons.delete), iconSize: 18,)
                                    ],
                                  ),
                                );
                              }
                          );
                        }
                      }
                  ),
                ],
              ),
              const SizedBox(height: 100),
              ExpansionTile(
                title: const Text("이번 달의 할 일", style: TextStyle(fontSize: 20)),
                children: [
                  Builder(
                      builder: (context) {
                        if (todoList.isEmpty) {
                          return const Center(child: Text("할 일을 작성해주세요!", style: TextStyle(fontSize: 18),));
                        }
                        else {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: todoList.length,
                              itemBuilder: (context, index) {
                                var todo = todoList.elementAt(index);
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(40, 0, 20, 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${todo.text} / ${DateFormat('yyyy-MM-dd').format(todo.startDate)} ~ ${DateFormat('yyyy-MM-dd').format(todo.finishDate)}', style: const TextStyle(fontSize: 18),),
                                      IconButton(onPressed: () => deleteTodoIndex(index), icon: const Icon(Icons.delete), iconSize: 18,)
                                    ],
                                  ),
                                );
                              }
                          );
                        }
                      }
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
