class TaskModel {
  final String id;
  final String title;
  final String? subtitle;
  final bool isCompleted;
  final String priority;
  final DateTime time;
  final Duration? period;

  TaskModel({
    required this.id,
    required this.title,
    required this.priority,
    required this.time,
    this.subtitle,
    this.period,
    this.isCompleted = false,
  });

  TaskModel copyWith({bool? isCompleted}) {
    return TaskModel(
      id: id,
      title: title,
      priority: priority,
      time: time,
      subtitle: subtitle,
      period: period,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'isCompleted': isCompleted,
      'priority': priority,
      'time': time.toIso8601String(),
      'period': period?.inMinutes,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      priority: json['priority'],
      time: DateTime.parse(json['time']),
      period: json['period'] != null ? Duration(minutes: json['period']) : null,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
