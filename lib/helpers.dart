RegExp dateRegex =
    RegExp(r'(\d{4})[\-](0?[1-9]|1[012])[\-](0?[1-9]|[12][0-9]|3[01])$');

bool isPriorityString(String prioString) =>
    prioString.length == 3 &&
    prioString[0] == '(' &&
    prioString[2] == ')' &&
    prioString.codeUnitAt(1) >= 65 &&
    prioString.codeUnitAt(1) <= 90;

bool isDateString(String date) => dateRegex.hasMatch(date);

String dateToDateString(DateTime date) =>
    '${date.year} ${date.month} ${date.day}';

String paramsToString(Map params) {
  var strParams = '';
  params.forEach((key, value) => strParams += ' $key:$value');
  return strParams.trim();
}
