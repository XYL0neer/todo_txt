library todo_txt;

RegExp dateRegex =
    RegExp(r'(\d{4})[\-](0?[1-9]|1[012])[\-](0?[1-9]|[12][0-9]|3[01])$');

class Todo {
  bool completed;
  String title;
  int? priority;
  DateTime? completionDate;
  DateTime? creationDate;
  List<String> project;
  List<String> context;
  Map<String, String> metadata;

  Todo({
    required this.completed,
    required this.title,
    this.priority,
    this.completionDate,
    this.creationDate,
    this.project = const [],
    this.context = const [],
    this.metadata = const {},
  });

  /// check positional args and remove them from list: completed, priority, creation-date
  /// incompleted example: (A) <- Priority 2022-03-21 <- creationDate ...
  /// completed full example: x <- completed 2022-03-22 <- completionDate 2022-03-21 <-creation Date
  /// completion replaces priority because there is no real use for prio on completed todos, which can be additionally sorted by latest completed
  factory Todo.fromText(String todoLine) {
    var elements = todoLine.split(' ');
    var completed = false;
    var title = '';
    int? priority;
    DateTime? creationDate;
    DateTime? completionDate;
    var projects = <String>[];
    var contexts = <String>[];
    var params = <String, String>{};

    // if completed
    if (elements[0] == 'x') {
      completed = true;
      elements.removeAt(0);
      // followed by completion Date
      if (isDateString(elements[0])) {
        completionDate = DateTime.tryParse(elements[0]);
        elements.removeAt(0);
      }
      // else if prio
    } else if (isPriorityString(elements[0])) {
      priority = elements[0].codeUnitAt(1);
      elements.removeAt(0);
    }

    // creationDate comes directly after priority or completion
    if ((priority != null || completionDate != null) &&
        isDateString(elements[0])) {
      creationDate = DateTime.tryParse(elements[0]);
      elements.removeAt(0);
    }

    // remaining elements can be parsed on easy for loop @ -> context + -> projet contains : -> key/value pair
    for (var element in elements) {
      if (element.startsWith('@')) {
        contexts.add(element.substring(1));
      } else if (element.startsWith('+')) {
        projects.add(element.substring(1));
      } else if (element.contains(':')) {
        var param = element.split(':');
        params[param[0]] = param[1];
      } else {
        title += ' $element';
      }
    }

    title = title.trim();

    return Todo(
        completed: completed,
        title: title,
        priority: priority,
        creationDate: creationDate,
        completionDate: completionDate,
        context: contexts,
        project: projects,
        metadata: params);
  }

  String toText() {
    var text = '';

    if (completed) {
      text += 'x';
      if (completionDate != null) {
        text += ' ${dateToDateString(completionDate!)}';
      }
    } else if (priority != null) {
      text += '(${String.fromCharCode(priority!)})';
    }

    if (creationDate != null) {
      text += ' ${dateToDateString(creationDate!)}';
    }

    text += ' $title';
    text += ' ${context.map((e) => '@$e').join(' ')}';
    text += ' ${project.map((e) => '+$e').join(' ')}';
    text += ' ${paramsToString(metadata)}';

    text = text.trim();
    return text;
  }

  String dateToDateString(DateTime date) =>
      '${date.year} ${date.month} ${date.day}';

  String paramsToString(Map params) {
    var strParams = '';
    params.forEach((key, value) => strParams += ' $key:$value');
    return strParams.trim();
  }

  static bool isPriorityString(String prioString) =>
      prioString.length == 3 &&
      prioString[0] == '(' &&
      prioString[2] == ')' &&
      prioString.codeUnitAt(1) >= 65 &&
      prioString.codeUnitAt(1) <= 90;

  static bool isDateString(String date) => dateRegex.hasMatch(date);
}
