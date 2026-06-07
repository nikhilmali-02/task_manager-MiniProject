import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/bloc/task_bloc.dart';
import 'package:task_manager/bloc/task_event.dart';
import 'package:task_manager/models/TaskModel.dart';

import '../bloc/TaskState.dart';

class EditTaskScreen extends StatefulWidget {
  final String id;
  const EditTaskScreen({super.key, required this.id});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreen();
}

class _EditTaskScreen extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  String _selectedPriority = 'Medium';
  DateTime? _selectedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<TaskBloc>().state;
      if (state is TaskLoadedState) {
        final task = state.task.firstWhere((t) => t.id == widget.id);
        _titleController.text = task.title;
        _subtitleController.text = task.subtitle ?? '';
        _selectedPriority = task.priority;
        _selectedTime = task.time;
      }
    });
  }

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
        title: Text("Edit Task"),
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
                      id: widget.id,
                      title: _titleController.text,
                      subtitle: _subtitleController.text.isEmpty
                          ? null
                          : _subtitleController.text,
                      priority: _selectedPriority,
                      time: _selectedTime ?? DateTime.now(),
                    );
                    context.read<TaskBloc>().add(UpdateTaskEvent(task: task));
                    context.pop();
                  }
                },
                child: Text('Update'),
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
