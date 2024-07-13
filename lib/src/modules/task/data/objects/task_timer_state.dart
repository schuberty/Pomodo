class TaskTimerState {
  TaskTimerState({required this.duration, this.isRunning = false});

  final Duration duration;
  final bool isRunning;

  TaskTimerState copyWith({Duration? duration, bool? isRunning}) {
    return TaskTimerState(
      duration: duration ?? this.duration,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
