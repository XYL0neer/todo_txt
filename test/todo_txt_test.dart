import 'dart:developer';
import 'dart:io';

import 'package:test/test.dart';

import 'package:todo_txt/todo_txt.dart';

const path = "C:\\Users\\Adrian\\Projects\\todo_txt\\test\\resources\\todo.txt";

void main() {
  test('Try create a new TodoTxt file', () {
    cleanupFile();
    var tasks = [Task(completed: false, title: 'Task 1')];

    var todo = TodoTxt.create(tasks: tasks, path: path);

    expect(todo.tasks, tasks);
    expect(todo.path, path);
  });

  test('Try create a new TodoTxt file without .txt ending', () {
    var tasks = [Task(completed: false, title: 'Task 1')];

    expect(
        () => TodoTxt.create(
            tasks: tasks,
            path:
                "C:\\Users\\Adrian\\Projects\\todo_txt\\test\\resources\\todo.csv"),
        throwsA(isA<FormatException>()));
  });

  test('read from file', () {
    var tasks = [Task(completed: false, title: 'Task 1')];

    var todo = TodoTxt.readFromFile(path: path);

    expect(todo.path, path);
    expect(todo.tasks.length, tasks.length);
    expect(todo.tasks[0].title, 'Task 1');
  });
}

void cleanupFile() {
  try {
    File(path).deleteSync();
  } on Exception catch (e) {
    log(e.toString());
  }
}
