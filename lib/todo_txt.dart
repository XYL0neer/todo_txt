library todo_txt;

import 'dart:io';

import 'package:todo_txt/helpers.dart';
import 'package:todo_txt/task.dart';
export 'package:todo_txt/task.dart';

class TodoTxt {
  String path;
  List<Task> tasks;

  TodoTxt._({required this.path, required this.tasks});

  /// read existing Tasks from File at [path]
  factory TodoTxt.readFromFile({required String path}) {
    var osPath = pathToPlatformPath(path);
    if (!osPath.endsWith(".txt")) {
      throw const FormatException("File has to end with .txt");
    }
    try {
      var file = File(osPath);
      var lines = file.readAsLinesSync();
      var tasks = lines.map((line) => Task.fromText(line)).toList();
      return TodoTxt._(path: osPath, tasks: tasks);
    } on FileSystemException catch (ex) {
      print(ex.message);
      rethrow;
    }
  }

  /// Creates and writes tasks to path
  ///
  /// [tasks] List of [Task] to store into the file specified by the [path]
  factory TodoTxt.create({required List<Task> tasks, required String path}) {
    var osPath = pathToPlatformPath(path);
    if (!osPath.endsWith(".txt")) {
      throw const FormatException("File has to end with .txt");
    }
    if (File(osPath).existsSync()) {
      throw Exception('Specified file $osPath already exists');
    }

    var todoTxt = TodoTxt._(path: osPath, tasks: tasks);
    todoTxt.writeToFile();
    return todoTxt;
  }

  /// Writes the tasks of TodoTxt into the path
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
