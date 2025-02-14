import 'package:flutter/material.dart';
import 'package:to_do/components/dialog_box.dart';
import 'package:to_do/components/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do/data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    //if this is first time then create default data
    if(_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    }else {
      //there already exist data
      db.loadData();
    }
    // TODO: implement initState
    super.initState();
  }

  final _controller = TextEditingController();



  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1]; // Update the completed status
    });
    db.updateDatabase();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();

  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );

        },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDatabase();





  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: Text('To Do',
            style: TextStyle(fontSize: 25)
        ),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {createNewTask();},
          child: Icon(Icons.add),
        backgroundColor: Colors.purple[100],
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context,index) {
          return TodoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              onChanged: (value) => checkBoxChanged(value,index),
              deleteFunction: (context) => deleteTask(index)
          );
        },
      ),
    );
  }
}
