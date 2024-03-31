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