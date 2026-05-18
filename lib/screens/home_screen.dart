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

  String _formatDateTime(DateTime time){
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final taskDate = DateTime(time.year, time.month, time.day);

    String dateLabel;
    if (taskDate == today){
      dateLabel = 'Today';
    } else if (taskDate == tomorrow){
      dateLabel = 'Tommorrow';
    } else {
      dateLabel = '${time.day}/${time.month}/${time.year}';
    }

    final hour = time.hour == 0 ? 12 : time.hour > 12  ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2,'0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$dateLabel,$hour:$minute $period';
  }

  Color _priorityColor(String priority) {
    switch (priority){
      case 'High': return Colors.red;
      case 'Medium' : return Colors.orange;
      case 'Low' : return Colors.green;
      default: return Colors.grey;
    }
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
          IconButton(onPressed: () => context.push('/setting'), icon: Icon(Icons.settings))
        ],
        title: Text('MyTasks'),
      ),
      body: controller.isLoading
          ? Center(child: CircularProgressIndicator())
          : controller.error != null
              ?Center(child: Text(controller.error!),)
              : controller.completedList.isEmpty && controller.incompeletedList.isEmpty
                  ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('No Tasks Yet!', style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 8),
            Text('Tap + to add a task', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      )
                  : ListView.builder(
                    itemCount: allTask.length,
                    itemBuilder: (context,index){
                    final task = allTask[index];
                    return Dismissible(key: Key(task.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.delete,color: Colors.white),
                        ),
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
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(task.subtitle ?? '',),
                                Text(_formatDateTime(task.time), style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                              leading: Checkbox(value: task.isCompleted,
                                onChanged: (_) => context.read<TaskController>().toggleTask(task)),
                              trailing: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical:4),
                                    decoration: BoxDecoration(
                                      color: _priorityColor(task.priority),
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Text(task.priority,style: TextStyle(color: Colors.white, fontSize: 12),),
                                  ),
                                  if(task.isCompleted == false)
                                    IconButton(onPressed: () {
                                      context.push('/edit/${task.id}');
                                    }, icon: Icon(Icons.edit))
                                ],
                              ),
                          ),
                        )
                    );
                  },)

    );
  }
}