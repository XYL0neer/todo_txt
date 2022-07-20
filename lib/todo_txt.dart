library todo_txt;

import 'dart:io';

import 'package:todo_txt/task.dart';
export 'package:todo_txt/task.dart';

class TodoTxt {
  String path;
  List<Task> tasks;

  TodoTxt._({required this.path, required this.tasks});

  factory TodoTxt.readFromFile(String path) {
    if (!path.endsWith(".txt")) {
      throw const FormatException("File has to end with .txt");
    }
    try {
      var file = File(path);
      var lines = file.readAsLinesSync();
      var tasks = lines.map((line) => Task.fromText(line)).toList();
      return TodoTxt._(path: path, tasks: tasks);
    } on FileSystemException catch (ex) {
      print(ex.message);
      rethrow;
    }
  }

  factory TodoTxt.create({required List<Task> tasks, required String path}) {
    if (!path.endsWith(".txt")) {
      throw const FormatException("File has to end with .txt");
    }
    return TodoTxt._(path: path, tasks: tasks);
  }

  void writeToFile() {
    try {
      var file = File(path);
      var lines = tasks.map((task) => task.toText());
      file.writeAsStringSync(lines.join('\n'), flush: true);
    } on FileSystemException catch (ex) {
      print(ex);
      rethrow;
    }
  }
}
