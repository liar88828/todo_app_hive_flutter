import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_hive/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Todo> todoBox;
  @override
  void initState() {
    super.initState();
    todoBox = Hive.box<Todo>('todo');
  }

  void _addTodo(String title, String description) {
    if (title.isNotEmpty && description.isNotEmpty) {
      todoBox.add(Todo(
        title: title,
        description: description,
        dateTime: DateTime.now(),
      ));
    }
  }

  void _checkTodo(Todo todo, bool? value) {
    setState(() {
      todo.isCompleted = value!;
      todo.save();
    });
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      todo.delete();
    });
  }

  void _addTodoDialog(BuildContext context) {
    TextEditingController _titleController = TextEditingController();
    TextEditingController _descController = TextEditingController();

    void _saveTodo(BuildContext context) {
      _addTodo(_titleController.text, _descController.text);
      _titleController.clear();
      _descController.clear();
      Navigator.pop(context);
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Add Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Title')),
                    TextField(
                        controller: _descController,
                        decoration:
                            const InputDecoration(labelText: 'Description'))
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        _saveTodo(context);
                      },
                      child: Text('Apply'))
                ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // backgroundColor: Colors.,

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addTodoDialog(context);
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          elevation: 0,
          title: Text('Todo List'),
        ),
        body: ValueListenableBuilder(
          valueListenable: todoBox.listenable(),
          builder: (context, Box<Todo> box, _) {
            return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  Todo todo = box.getAt(index)!;
                  return Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: todo.isCompleted
                            ? Colors.green.withOpacity(.1)
                            : Colors.red.withOpacity(.1)),
                    child: Builder(builder: (context) {
                      return Dismissible(
                        onDismissed: (direction) {
                          _deleteTodo(todo);
                        },
                        key: Key(todo.dateTime.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.redAccent,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ListTile(
                          title: Text(todo.title),
                          subtitle: Text(todo.description),
                          trailing:
                              Text(DateFormat.yMMMEd().format(todo.dateTime)),
                          leading: Checkbox(
                            value: todo.isCompleted,
                            onChanged: (value) {
                              _checkTodo(todo, value);
                            },
                          ),
                        ),
                      );
                    }),
                  );
                });
          },
        ));
  }
}
