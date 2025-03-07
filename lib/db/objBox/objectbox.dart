

// import 'package:taskmanager/objectbox.g.dart';


import 'package:path_provider/path_provider.dart';
import 'package:taskmanager/objectbox.g.dart';

import '../../model/task_model.dart';


class ObjectBox{
  late final Store store;
  late final Box<TaskModel> taskBox;

  ObjectBox._create(this.store){
    taskBox = Box<TaskModel>(store);
  }
  static Future<ObjectBox> create() async {
    final dir = await getApplicationDocumentsDirectory();
    final store = Store(getObjectBoxModel(),directory: dir.path);


    // final store = await openStore();  // Open the ObjectBox store
    return ObjectBox._create(store);
  }
  void close() {
    store.close();  // Close the store to free resources
  }
  // Fetch completed tasks
  List<TaskModel> getCompletedTasks() {
    final query = taskBox.query(TaskModel_.status.equals('Completed')).build();
    final tasks = query.find();
    query.close();

    print("yyyyyyyyyyyyy >>>${tasks.single.status}");
    return tasks;
  }


}