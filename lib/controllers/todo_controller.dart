import 'package:flutter_application_1/models/todo.dart';
import 'package:get/get.dart';

class TodoController extends GetxController {
  RxList<Todo> todos = <Todo>[].obs;
  int _nextId = 0;

  void addTodo({
    required String judul,
    required String deskripsi,
    required DateTime date,
  }) {
    final todo = Todo(
      id: _nextId,
      judul: judul,
      deskripsi: deskripsi,
      date: date,
    );
    todos.add(todo);
    _nextId++;
  }

  void removeTodoById(int id) {
    todos.removeWhere((t) => t.id == id);
  }

  void status(int id) {
    final idx = todos.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    todos[idx].status = !todos[idx].status;
    todos.refresh();
  }

  void updateTodo({
    required int id,
    String? title,
    String? description,
    DateTime? date,
  }) {
    final idx = todos.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    final t = todos[idx];
    if (title != null) t.judul = title;
    if (description != null) t.deskripsi = description;
    if (date != null) t.date = date;
    todos[idx] = t;
  }
}
