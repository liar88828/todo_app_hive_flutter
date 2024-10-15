import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app_hive/screens/home_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todo');
  runApp(const MyApp());
}

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late bool isCompleted;

  @HiveField(3)
  late DateTime dateTime;

  Todo({
    required this.title,
    required this.description,
    // required this.isCompleted,
    this.isCompleted = false,
    required this.dateTime,
  });
}

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  int get typeId => 0;

  @override
  Todo read(BinaryReader reader) {
    return Todo(
        title: reader.readString(),
        description: reader.readString(),
        dateTime: DateTime.parse(reader.readString()),
        isCompleted: reader.readBool());
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeString(obj.dateTime.toIso8601String());
    writer.writeBool(obj.isCompleted);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
