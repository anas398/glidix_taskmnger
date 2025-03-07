
import 'package:objectbox/objectbox.dart';

@Entity()
class TaskModel{
  @Id()
  int id=0;
  String title;
  String description;
  String priority;
  String status;
  DateTime endDate;
      // New field for conflict resolution

  TaskModel({
    this.id=0,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.endDate,

  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'priority': priority,
      'status': status,
      'endDate': endDate.toIso8601String(),
    };
  }

  // Create Task from a Firestore Map
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      title: map['title'],
      description: map['description'],
      priority: map['priority'],
      status: map['status'],
      endDate: DateTime.parse(map['endDate']),
    );
  }

  // Check if the task is overdue
  bool get isOverdue {
    return DateTime.now().isAfter(endDate);
  }

  // Check if the deadline is within 24 hours
  bool get isApproachingDeadline {
    final now = DateTime.now();
    final difference = endDate.difference(now).inHours;
    return difference > 0 && difference <= 24;
  }
}