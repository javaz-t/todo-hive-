import 'package:hive/hive.dart';

part 'todo_hive.g.dart';

@HiveType(typeId: 1)
class TodoHive {
  TodoHive({required this.name});
  @HiveField(0)
  String name;
}
