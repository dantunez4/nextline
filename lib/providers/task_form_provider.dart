import 'package:flutter/material.dart';
import 'package:gestion_tareas/models/task.dart';

class TaskFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Task task;

  TaskFormProvider(this.task);

  updateIsCompleted(bool value) {
    value ? task.isCompleted = 1 : task.isCompleted = 0;

    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
