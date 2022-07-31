import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_txt/todo_txt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'todo_txt example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'todo_txt example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TodoTxt _todoTxt;
  var _isLoaded = false;
  final _textController = TextEditingController();

  @override
  void initState() {
    createTaskFile();
    super.initState();
  }

  void createTaskFile() async {
    var appDocDir = await getApplicationDocumentsDirectory();
    var txt;
    try {
      txt = TodoTxt.readFromFile(path: '${appDocDir.path}/todo.txt');
    } on FileSystemException catch (e) {
      print(e);
      txt = TodoTxt.create(tasks: [], path: '${appDocDir.path}/todo.txt');
    } finally {
      setState(() {
        _todoTxt = txt;
        _isLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    _todoTxt.writeToFile();
    _textController.dispose();
    super.dispose();
  }

  void _addNewTask(String taskTitle) {
    setState(() {
      _todoTxt.tasks = [..._todoTxt.tasks, Task(taskTitle)];
    });
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () => _todoTxt.writeToFile(),
              icon: const Icon(Icons.save))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: _isLoaded
                ? ListView.separated(
                    itemCount: _todoTxt.tasks.length,
                    separatorBuilder: (context, index) =>
                        const Divider(thickness: 1.0),
                    itemBuilder: (context, index) => ListTile(
                      title: Text(_todoTxt.tasks[index].title),
                      leading: Checkbox(
                        value: _todoTxt.tasks[index].completed,
                        onChanged: (checked) => setState(() {
                          _todoTxt.tasks[index].completed = checked ?? false;
                        }),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(),
          ),
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'What do you need to do?',
                  suffixIcon: IconButton(
                    onPressed: () => _addNewTask(_textController.text),
                    icon: const Icon(Icons.add),
                  ),
                ),
                onSubmitted: _addNewTask,
                controller: _textController,
              ),
            ),
          )
        ],
      ),
    );
  }
}
