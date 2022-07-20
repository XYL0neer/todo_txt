import 'package:flutter_test/flutter_test.dart';

import 'package:todo_txt/todo_txt.dart';

void main() {
  test('isPriorityString validPrioString returnTrue', () {
    var prioString = '(A)';
    expect(Todo.isPriorityString(prioString), true);
  });

  test('isPriorityString invalidPrioString returnFalse', () {
    var prioString = '(a)';
    expect(Todo.isPriorityString(prioString), false);
  });

  test('isDate validDate returnTrue', () {
    var dateString = '1999-03-22';
    expect(Todo.isDateString(dateString), true);
  });

  test('isDate swappedDayMonth returnFalse', () {
    var dateString = '1999-22-03';
    expect(Todo.isDateString(dateString), false);
  });

  test('isDate 2BigValueForDay returnFalse', () {
    var dateString = '1999-03-33';
    expect(Todo.isDateString(dateString), false);
  });

  test('isDate 2BigValueForMonth returnFalse', () {
    var dateString = '1999-13-22';
    expect(Todo.isDateString(dateString), false);
  });
}
