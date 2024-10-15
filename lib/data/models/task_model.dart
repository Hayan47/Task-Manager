import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  const Task({
    this.id = 0,
    this.todo = '',
    this.completed = true,
    this.userId = 0,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      todo: json['todo'] ?? '',
      completed: json['completed'] ?? true,
      userId: json['userId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'todo': todo,
      'completed': completed,
      'userId': userId,
    };
  }

  @override
  List<Object?> get props => [id, todo, completed, userId];
}
