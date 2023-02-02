import 'package:flutter/material.dart';
import 'package:gestion_tareas/providers/task_form_provider.dart';
import 'package:gestion_tareas/services/tasks_service.dart';
import 'package:gestion_tareas/ui/input_decorations.dart';
import 'package:provider/provider.dart';

class TaskFormScreen extends StatelessWidget {
  const TaskFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tasksService = Provider.of<TasksService>(context);

    return ChangeNotifierProvider(
      create: (context) => TaskFormProvider(
        tasksService.selectedTask,
      ),
      child: _TaskFormScreenBody(
        tasksService: tasksService,
      ),
    );
  }
}

class _TaskFormScreenBody extends StatelessWidget {
  const _TaskFormScreenBody({
    Key? key,
    required this.tasksService,
  }) : super(key: key);

  final TasksService tasksService;

  @override
  Widget build(BuildContext context) {
    final taskForm = Provider.of<TaskFormProvider>(context);
    final task = taskForm.task;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            //child: _FormScreenBody(tasksService: tasksService),
            //create or edit task form
            child: Form(
              key: taskForm.formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: task.title,
                    onChanged: (value) => task.title = value,
                    validator: (value) {
                      if (value == null || value.length < 3) {
                        return 'El título es obligatorio';
                      }
                      return null;
                    },
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Título',
                      labelText: 'Titulo:*',
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    initialValue: task.description,
                    onChanged: (value) => task.description = value,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Descripción',
                      labelText: 'Descripción:',
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    initialValue: task.comments,
                    onChanged: (value) => task.comments = value,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Comentarios',
                      labelText: 'Comentarios:',
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    initialValue: task.tags,
                    onChanged: (value) => task.tags = value,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Tags',
                      labelText: 'Tags:',
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    initialValue: task.dueDate,
                    onChanged: (value) {
                      task.dueDate = value;
                    },
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Fecha',
                      labelText: 'Fecha:',
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  SwitchListTile.adaptive(
                    value: task.isCompleted == 1 ? true : false,
                    title: const Text('Completada'),
                    activeColor: Colors.indigo,
                    onChanged: taskForm.updateIsCompleted,
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: FloatingActionButton(
              heroTag: null,
              child: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          FloatingActionButton(
            child: const Icon(Icons.save_outlined),
            onPressed: () async {
              if (!taskForm.isValidForm()) return;
              await tasksService.saveOrCreateTask(task);
            },
          ),
        ],
      ),
    );
  }
}
