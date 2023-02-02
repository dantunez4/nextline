import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_tareas/models/task.dart';
import 'package:http/http.dart' as http;

class TasksService extends ChangeNotifier {
  final String _baseUrl = 'ecsdevapi.nextline.mx';
  final String _token =
      'e864a0c9eda63181d7d65bc73e61e3dc6b74ef9b82f7049f1fc7d9fc8f29706025bd271d1ee1822b15d654a84e1a0997b973a46f923cc9977b3fcbb064179ecd';
  final List<Task> tasks = [];
  late Task selectedTask;
  bool isLoading = true;
  bool isSaving = false;

  TasksService() {
    loadTasks();
  }

  // get request to upload tasks to task list
  Future<List<Task>> loadTasks() async {
    isLoading = true;

    notifyListeners();

    final url =
        Uri.https(_baseUrl, '/vdev/tasks-challenge/tasks', {'token': _token});

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    });

    // get json from json string
    final decodedData = json.decode(response.body);

    // get tasks from json list
    for (int i = 0; i < decodedData.length; i++) {
      final temptask = Task.fromJson(decodedData[i]);
      tasks.add(temptask);
    }

    isLoading = false;

    notifyListeners();
    return tasks;
  }

  // get request to get task by id
  Future<Task> loadTaskId(int id) async {
    final url = Uri.https(
        _baseUrl, '/vdev/tasks-challenge/tasks/$id', {'token': _token});

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    });

    // get json from json string
    final decodedData = json.decode(response.body);

    // get task from json
    if (decodedData[0] != null) {
      selectedTask = Task.fromJson(decodedData[0]);
    }

    return selectedTask;
  }

  Future saveOrCreateTask(Task task) async {
    isSaving = true;
    notifyListeners();

    if (task.id == null) {
      await createTask(task);
    } else {
      await updateTask(task);
    }

    isSaving = false;
    notifyListeners();
  }

  // update task
  Future<int> updateTask(Task task) async {
    final url = Uri.https(
        _baseUrl, '/vdev/tasks-challenge/tasks/${task.id}', {'token': _token});

    await http.put(url, body: task.toRawJson(), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    });

    // get index to update list task
    final index = tasks.indexWhere((element) => element.id == task.id);
    tasks[index] = task;

    return task.id!;
  }

  // create new task
  Future<int> createTask(Task task) async {
    final url =
        Uri.https(_baseUrl, '/vdev/tasks-challenge/tasks', {'token': _token});

    final response = await http.post(url, body: task.toRawJson(), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    });

    // get json from json string
    final decodedData = json.decode(response.body);

    // get task from json
    task = Task.fromJson(decodedData['task']);

    // add new task to list
    tasks.add(task);

    return task.id!;
  }

  Future<void> deleteTask(int id) async {
    final url = Uri.https(
        _baseUrl, '/vdev/tasks-challenge/tasks/$id', {'token': _token});

    await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    });

    // delete task from task list
    tasks.removeWhere((element) => element.id == id);

    notifyListeners();
  }
}
