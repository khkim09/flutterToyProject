# todoList toy_project1

TodoList 생성

## syllabus

1. 화면 구현
2. newtodoscreen 구현
    - 2-1) [할일] 작성
    - 2-2) [시작날짜, 시간] pick
    - 2-3) [종료날짜, 시간] pick
    - 2-4) [메모] 작성
3. '완료' 버튼 클릭 시 mainscreen 저장
4. Hive로 앱 종료 시에도 저장되도록 구현
5. 리스트 시간 순 정렬 구현
6. firebase 구현


## issues
1. 회원가입 -> 로그인 시, 개인 todolist로 실행 X (모두 일관된 data 가짐) - 24.04.05
      firestore를 통해 해결해야 되는 것으로 보임
2. 로그인 성공 시, Navigator.push로 인해 뒤로가기 버튼 생성됨
    임시방편으로, ```dartleading: const Placeholder(), leadingWidth: 0,``` -> 화면 왼쪽 끝에 까만 선 생김


## hive 사용 설명서

Hive 구조 건설
```dart
import 'package:hive/hive.dart';

part 'todo_adapter.dart';

@HiveType(typeId: 0)
class TodoBox extends HiveObject {
  @HiveField(0)
  String text = "";

  @HiveField(1)
  DateTime startDate = DateTime.now();

  @HiveField(2)
  DateTime finishDate = DateTime.now();

  @HiveField(3)
  DateTime startTime = DateTime.now();

  @HiveField(4)
  DateTime finishTime = DateTime.now();

  @HiveField(5)
  String memo = "";

  @HiveField(6)
  bool isCompleted = false;
}
```

Hive adapter 사용법
```dart
//Do not modify code - TypeAdapter Generator

part of 'todo_box.dart';

class TodoAdapter extends TypeAdapter<TodoBox> {
  @override
  final typeId = 0;

  @override
  TodoBox read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoBox()
      ..text = fields[0] as String
      ..startDate = fields[1] as DateTime
      ..finishDate = fields[2] as DateTime
      ..startTime = fields[3] as DateTime
      ..finishTime = fields[4] as DateTime
      ..memo = fields[5] as String
      ..isCompleted = fields[6] as bool;
  }

  @override
  void write(BinaryWriter writer, TodoBox obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.finishDate)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.finishTime)
      ..writeByte(5)
      ..write(obj.memo)
      ..writeByte(6)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TodoAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
```

Hive 불러오기 (저장 값 받아오기)
```dart
var todoList = Hive.box<TodoBox>('myBox').values.toList().cast<TodoBox>();
```

> - Hive.box<TodoBox>('myBox'): Hive 데이터베이스에서 'myBox'라는 이름의 상자 열기.
>     - 여기서 TodoBox는 Hive 상자에 저장된 개체의 유형. 데이터베이스에서 저장된 항목의 유형을 지정
> - .values.toList(): 상자 안에 있는 모든 항목을 값으로 호출, 리스트로 변환. (상자에 있는 모든 값 호출 가능)
> - .cast<TodoBox>(): 호출한 값들을 TodoBox 객체로 캐스트하여 형식을 지정. (List 모든 요소 -> TodoBox 객체로 캐스트)
> - var todoList = ...: 가져온 TodoBox 객체들의 list를 todoList 변수에 할당.
> - 결과 : todoList 변수는 'myBox' 상자에서 가져온 모든 TodoBox 객체를 포함하는 list.

Hive 쓰기 (Hive에 저장하기)
```dart
var newTodo = TodoBox()
        ..text = newText
        ..startDate = startDate
        ..finishDate = finishDate
        ..startTime = startTime
        ..finishTime = finishTime
        ..memo = newMemo;

Hive.box<TodoBox>('myBox').add(newTodo);
```

> TodoBox.."key" = "value"; 로 저장
> 
> 마지막에 Hive.box<TodoBox>('myBox').add(newTodo); 로 Hive에 추가


## Firebase 사용 설명서

> 하단 링크 참고
> <https://www.notion.so/Flutter-Firebase-19eb42b0dc984be0b38d439f436abfd5?pvs=4>


FirebaseAuth의 메서드 설명
```dart
onPressed: () async{
   try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
         email: emailController.text.toString(),
         password: pwController.text.toString()
      );
      Get.offAll(() => const MainScreen());
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
}
```

> signInWithEmailAndPassword -> 단순히 Firebase에 (해당 계정 : 비밀번호) 존재 여부 파악
> createUserWithEmailAndPassword -> Firebase에 (계정 : 비번) 생성
> userCredential 변수 -> 큰 의미 없음 / await FirebaseAuth.instance.signInWithEmailAndPassword 로 바로 써도 무관