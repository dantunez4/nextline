import 'package:flutter/material.dart';
import 'package:gestion_tareas/models/task.dart';
import 'package:gestion_tareas/screens/loading_screen.dart';
import 'package:gestion_tareas/services/tasks_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // call provider taskService
    final tasksService = Provider.of<TasksService>(context);

    if (tasksService.isLoading) return const LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        centerTitle: true,
      ),
      body: ListView.separated(
        separatorBuilder: (_, index) => const Divider(),
        itemBuilder: (context, index) {
          return _BuildDismissible(
            task: tasksService.tasks[index],
            index: index,
          );
        },
        itemCount: tasksService.tasks.length,
      ),
      // create new task
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          tasksService.selectedTask = Task(title: '', isCompleted: 0);
          Navigator.pushNamed(context, 'task');
        },
      ),
    );
  }
}

// building dismissible
class _BuildDismissible extends StatelessWidget {
  final Task task;
  final int index;

  const _BuildDismissible({
    Key? key,
    required this.task,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tasksService = Provider.of<TasksService>(context);
    return FutureBuilder(
      future: tasksService.loadTaskId(task.id!),
      builder: (_, AsyncSnapshot<Task> snapshot) {
        return Dismissible(
          direction: DismissDirection.endToStart,
          key: UniqueKey(),
          background: Container(
            // background dismissible
            alignment: Alignment.centerRight,
            color: Colors.red,
            child: const Padding(
              padding: EdgeInsets.only(
                right: 15.0,
              ),
              child: Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
          // delete task
          onDismissed: (DismissDirection direction) {
            tasksService.deleteTask(task.id!);
          },
          child: ListTile(
            leading: const Icon(
              Icons.task_outlined,
              color: Colors.blue,
            ),
            title: Text(task.title),
            subtitle: Text('${task.id}'),
            trailing: const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
            onTap: () async {
              await tasksService.loadTaskId(task.id!);
              Navigator.pushNamed(context, 'task');
            },
          ),
        );
      },
    );
  }
}
