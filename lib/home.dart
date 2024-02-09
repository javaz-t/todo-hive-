import 'package:blood_donation/box_todo.dart';
import 'package:blood_donation/todo_hive.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _update(int index) {
      TodoHive todoHive = boxTodo.getAt(index);
      titleController.text = todoHive.name;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Update task',
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {

                    todoHive.name = titleController.text;
                    boxTodo.putAt(index, todoHive);
                    titleController.clear();
                  });
                  Navigator.pop(context);
                },
                child: Text('Update'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    }



    ///adding new data
    _add() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'add task',
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    ///save to internal storage fn
                    setState(() {
                      boxTodo.put(
                          'key${titleController.text}',
                          TodoHive(
                            name: titleController.text,
                          ));
                    });
                    titleController.clear();

                    Navigator.pop(context);
                  },
                  child: Text('SAVE'),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'))
              ],
            );
          });
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _add();
          },
          child: Text('Add ')),
      appBar: AppBar(
        title: Text('Todo List '),
        backgroundColor: Colors.greenAccent,
      ),
      body: ListView.builder(
          itemCount: boxTodo.length,
          itemBuilder: (context, index) {
            TodoHive todoHive = boxTodo.getAt(index);
            return Card(
                child: ListTile(
              title: Text(todoHive.name),
              leading: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {_update(index);},
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    boxTodo.deleteAt(index);
                   /// to delete all :  boxTodo.clear();
                  });
                },
              ),
            ));
          }),
    );
  }
}
