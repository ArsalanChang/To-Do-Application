import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = [];

  //reference our box
final _myBox = Hive.box('mybox');

// run this method if this is first time opening this app ever
void createInitialData() {
  toDoList = [
    ["Make Tutorial", false],
    ["Do Exercise", false],
  ];
}

// load data from db

void loadData() {
  toDoList = _myBox.get("TODOLIST");
}

// update the db
void updateDatabase() {
  _myBox.put("TODOLIST", toDoList);

}
}