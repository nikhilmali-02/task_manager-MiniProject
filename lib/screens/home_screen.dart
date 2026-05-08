import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/Controllers/task_controller.dart';
import 'package:task_manager/main.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<HomeScreen> createState() => HomeScreen_State();
}

class HomeScreen_State extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<TaskController>().loadTask();
    });
  }

  @override
  Widget build(BuildContext context) {

    final controller = context.watch<TaskController>();

    final allTask = [
      ...controller.incompeletedList,
      ...controller.completedList,
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
        await context.push('/add');
        context.read<TaskController>().loadTask();
      },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () => context.go('/setting'), icon: Icon(Icons.settings))
        ],
        title: Text('MyTasks'),
      ),
      body: controller.isLoading
          ? Center(child: CircularProgressIndicator())
          : controller.completedList.isEmpty && controller.incompeletedList.isEmpty
              ? Center(child: Text('No Task Yet!'))
              : ListView.builder(
                  itemCount: allTask.length,
                  itemBuilder: (context,index){
                    final task = allTask[index];
                    return Dismissible(key: Key(task.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) =>   context.read<TaskController>().deleteTask(task),
                        child: Card(
                          child: ListTile(
                            title: Text(
                                task.title,
                              style: TextStyle(
                                decoration: task.isCompleted ? TextDecoration.lineThrough : null
                              ),
                            ),
                            subtitle: Text(task.subtitle ?? ''),
                              leading: Checkbox(value: task.isCompleted,
                                onChanged: (_) => context.read<TaskController>().toggleTask(task) ),
                              trailing: Text(task.priority),
                          ),
                        )
                    );
                  },)

    );
  }
}