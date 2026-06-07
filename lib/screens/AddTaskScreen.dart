import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/bloc/task_bloc.dart';
import 'package:task_manager/bloc/task_event.dart';
import 'package:task_manager/models/TaskModel.dart';
import 'package:uuid/uuid.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  String _selectedPriority = 'Medium';
  DateTime? _selectedTime;

  Future<DateTime?> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date == null) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _titleController,
                textAlign: TextAlign.left,
                decoration: const InputDecoration(labelText: 'Enter the Task'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Task';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _subtitleController,
                textAlign: TextAlign.left,
                decoration: const InputDecoration(labelText: 'Add Description'),
              ),
              DropdownButtonFormField<String>(
                initialValue: _selectedPriority,
                items: ['High', 'Medium', 'Low']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedPriority = value!),
                decoration: InputDecoration(labelText: "Priority"),
              ),
              ListTile(
                title: Text(
                  _selectedTime == null
                      ? 'Select Time'
                      : _selectedTime.toString(),
                ),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  final picked = await _pickDateTime();
                  if (picked != null) setState(() => _selectedTime = picked);
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final task = TaskModel(
                      id: const Uuid().v4(),
                      title: _titleController.text,
                      subtitle: _subtitleController.text.isEmpty
                          ? null
                          : _subtitleController.text,
                      priority: _selectedPriority,
                      time: _selectedTime ?? DateTime.now(),
                    );
                    context.read<TaskBloc>().add(AddTaskEvent(task: task));
                    context.pop();
                  }
                },
                child: Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }
}
