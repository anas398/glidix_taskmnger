import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmanager/model/task_model.dart';

class FirestoreService {
  final CollectionReference tasksCollection =
  FirebaseFirestore.instance.collection('tasks');

  Future<void> syncCompletedTask(TaskModel task) async {
    try {
      await tasksCollection.doc(task.id.toString()).set({
        'title': task.title,
        'description': task.description,
        'priority': task.priority,
        'status': task.status,
        'endDate': task.endDate.toIso8601String(),
        'lastUpdated': DateTime.now().toIso8601String(),
      });
      print('Task synced to Firestore.');
    } catch (e) {
      print('Error syncing task: $e');
    }
  }
}
