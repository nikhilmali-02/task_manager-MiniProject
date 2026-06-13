import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/bloc/TaskState.dart';
import 'package:task_manager/bloc/task_bloc.dart';
import 'package:task_manager/bloc/task_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskBloc>().add(LoadTasksEvent());
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<TaskBloc>().add(LoadTasksEvent());
    }
  }

  String _formatDateTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final taskDate = DateTime(time.year, time.month, time.day);

    String dateLabel;
    if (taskDate == today) {
      dateLabel = 'Today';
    } else if (taskDate == tomorrow) {
      dateLabel = 'Tomorrow';
    } else {
      dateLabel = '${time.day}/${time.month}/${time.year}';
    }

    final hour = time.hour == 0
        ? 12
        : time.hour > 12
        ? time.hour - 12
        : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';

    return '$dateLabel, $hour:$minute $period';
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFE2574C);
      case 'Medium':
        return const Color(0xFFE6A623);
      case 'Low':
        return const Color(0xFF4A90E2);
      default:
        return const Color(0xFF8E8E93);
    }
  }

  Color _priorityBgColor(String priority, bool isDark) {
    switch (priority) {
      case 'High':
        return isDark ? const Color(0xFF4A1F1F) : const Color(0xFFF8D9D6);
      case 'Medium':
        return isDark ? const Color(0xFF3D2E0A) : const Color(0xFFF8EBCB);
      case 'Low':
        return isDark ? const Color(0xFF1A2E47) : const Color(0xFFDCEAFB);
      default:
        return isDark ? const Color(0xFF2C2C2E) : const Color(0xFFEAEAEA);
    }
  }

  Widget _buildQuickStats(int activeCount, int completedCount, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Active Tasks card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1A2E47), const Color(0xFF1D3557)]
                      : [const Color(0xFFDBEAFD), const Color(0xFFC3D8FB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 32,
                    color: Color(0xFF4A90E2),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Tasks',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? const Color(0xFF8E8E93)
                              : const Color(0xFF70757F),
                        ),
                      ),
                      Text(
                        '$activeCount',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? const Color(0xFFE5E5EA)
                              : const Color(0xFF1F2430),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Completed card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF0D2E1F), const Color(0xFF0F3526)]
                      : [const Color(0xFFD4EDDF), const Color(0xFFBAE3CE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 32,
                    color: Color(0xFF0F9D73),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Completed',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? const Color(0xFF8E8E93)
                              : const Color(0xFF70757F),
                        ),
                      ),
                      Text(
                        '$completedCount',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? const Color(0xFFE5E5EA)
                              : const Color(0xFF1F2430),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(dynamic task, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E2A38), const Color(0xFF1A2730)]
              : [const Color(0xFFEAF6FF), const Color(0xFFDFF3F7)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 28,
                  height: 28,
                  child: Checkbox(
                    value: task.isCompleted,
                    shape: const CircleBorder(),
                    side: const BorderSide(color: Color(0xFF4A90E2), width: 2),
                    activeColor: const Color(0xFF0F9D73),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    onChanged: (_) {
                      context.read<TaskBloc>().add(
                        ToggleTaskEvent(id: task.id),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? const Color(0xFFE5E5EA)
                          : const Color(0xFF1F2430),
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: isDark
                          ? const Color(0xFF8E8E93)
                          : const Color(0xFF70757F),
                    ),
                  ),
                ),
                if (!task.isCompleted)
                  IconButton(
                    onPressed: () => context.push('/edit/${task.id}'),
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  task.subtitle ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark
                        ? const Color(0xFF8E8E93)
                        : const Color(0xFF70757F),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _buildTag(
                  task.priority,
                  _priorityColor(task.priority),
                  _priorityBgColor(task.priority, isDark),
                ),
                const SizedBox(width: 10),
                _buildTag(
                  _formatDateTime(task.time),
                  const Color(0xFFD64545),
                  isDark ? const Color(0xFF3D1515) : const Color(0xFFF6D6D6),
                  icon: Icons.access_time_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(
    String text,
    Color textColor,
    Color bgColor, {
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: textColor),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1C1C1E), const Color(0xFF2C2C2E)]
                  : [const Color(0xFFF5F5F7), const Color(0xFFEEEEF3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 64,
                color: isDark ? const Color(0xFF48484A) : Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No tasks yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFFE5E5EA)
                      : const Color(0xFF1F2430),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create your first task to get started',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? const Color(0xFF8E8E93)
                      : const Color(0xFF70757F),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () async {
                  await context.push('/add');
                  if (mounted) {
                    context.read<TaskBloc>().add(LoadTasksEvent());
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF6C63FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Add Your First Task',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ── Single source of truth for dark mode ──
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1B1B1F)
          : const Color(0xFFF6F7FB),
      floatingActionButton: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: const Color(0xFF6C63FF),
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          onPressed: () async {
            await context.push('/add');
            if (mounted) context.read<TaskBloc>().add(LoadTasksEvent());
          },
          child: const Icon(Icons.add, size: 28),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF2A2840),
                    const Color(0xFF1F1F27),
                    const Color(0xFF1B1B1F),
                  ]
                : [
                    const Color(0xFFE9E8FF),
                    const Color(0xFFF7F7FB),
                    const Color(0xFFF6F7FB),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskLoadingState) {
                return Center(
                  child: CircularProgressIndicator(
                    color: const Color(0xFF6C63FF),
                    backgroundColor: isDark
                        ? const Color(0xFF2C2C2E)
                        : const Color(0xFFE9E8FF),
                  ),
                );
              } else if (state is TaskLoadedState) {
                final allTask = [
                  ...state.task.where((t) => !t.isCompleted),
                  ...state.task.where((t) => t.isCompleted),
                ];

                return Column(
                  children: [
                    // ── Header ──
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'My Tasks',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? const Color(0xFFE5E5EA)
                                    : const Color(0xFF1B1B1F),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => context.push('/setting'),
                            icon: Icon(
                              Icons.settings,
                              color: isDark
                                  ? const Color(0xFFE5E5EA)
                                  : const Color(0xFF1F2430),
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ── Quick Stats ──
                    _buildQuickStats(
                      state.activeCount(),
                      state.completedCount(),
                      isDark,
                    ),

                    const SizedBox(height: 20),

                    // ── Task List ──
                    Expanded(
                      child: allTask.isEmpty
                          ? _buildEmptyState(isDark)
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 120),
                              itemCount: allTask.length,
                              itemBuilder: (context, index) {
                                final task = allTask[index];
                                return Dismissible(
                                  key: Key(task.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 24),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onDismissed: (_) {
                                    context.read<TaskBloc>().add(
                                      DeleteTaskEvent(id: task.id),
                                    );
                                  },
                                  child: _buildTaskCard(task, isDark),
                                );
                              },
                            ),
                    ),
                  ],
                );
              } else if (state is TaskErrorState) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
