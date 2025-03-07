
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/screen/task_screen.dart';
import 'package:taskmanager/widgets/commonAppbar.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import '../providers/connectivity_provider.dart';
import '../providers/task_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Listen for connectivity changes
    Provider.of<ConnectivityProvider>(context, listen: false)
        .addListener(_onConnectivityChange);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    Provider.of<ConnectivityProvider>(context, listen: false)
        .removeListener(_onConnectivityChange);
    super.dispose();
  }

  void _onConnectivityChange() {
    final connectivityProvider =
    Provider.of<ConnectivityProvider>(context, listen: false);

    if (!connectivityProvider.isOnline) {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing by tapping outside
        builder: (context) => AlertDialog(
          title: Text('Offline'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'You are currently offline. Please check your internet connection.'),
              Lottie.asset("assets/offline.json")
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Dismiss the alert dialog when online
      // Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;
    final overdueTasks = context.watch<TaskProvider>().overdueTasks;
    final upcomingTasks = context.watch<TaskProvider>().upcomingTasks;
    return Scaffold(
      appBar: CommonAppbar(
        isShowSync: true,
        title: "Task Manager",
        showBackButton: false,
        home: true,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.file_upload),
                label: Text('Export Tasks',style: TextStyle(
                    color: Colors.white
                ),),
                onPressed: () async {
                  await taskProvider.exportTasks();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tasks exported successfully!')),
                  );
                },
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                icon: Icon(Icons.file_download),
                label: Text('Import Tasks'),
                onPressed: () async {
                  await taskProvider.importTasks();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tasks imported successfully!')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: tasks.isNotEmpty
          ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overdue Tasks Section
            if (overdueTasks.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Overdue Tasks",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: overdueTasks.length,
                itemBuilder: (context, index) {
                  final task = overdueTasks[index];
                  return Stack(
                    children: [
                      SizedBox(
                        height: 80,
                        child: WaveWidget(
                          config: CustomConfig(
                            gradients: _getWaveGradients(task.priority),
                            durations: [8000, 7000],
                            //heightPercentages: _getWaveHeightPercentages(tasks.length),
                            heightPercentages: [0.20, 0.23],
                            blur:
                            const MaskFilter.blur(BlurStyle.solid, 5),
                          ),
                          waveAmplitude: 17,
                          size: const Size(
                              double.infinity, double.infinity),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 1),
                        child: Slidable(
                          key: ValueKey(tasks[index]),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TaskScreen(
                                                mode: Mode.Edit,
                                                taskModel: task,
                                              )));
                                },
                                backgroundColor: Colors.blue,
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                              SlidableAction(
                                onPressed: (_) {
                                  taskProvider.deleteTask(task.id);
                                },
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: ListTile(
                            minTileHeight: 80,
                            tileColor: Colors.transparent,
                            title: Text(task.title,
                                style: TextStyle(
                                  fontWeight: isOverdue(task.endDate)
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isOverdue(task.endDate)
                                      ? Colors.red
                                      : Colors
                                      .black, // Red text for overdue tasks
                                )),
                            subtitle: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.description,
                                  style: TextStyle(
                                    fontStyle: isOverdue(task.endDate)
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
                                Text(
                                  'Due: ${DateFormat.yMMMd().format(task.endDate)}',
                                  style: TextStyle(
                                      color: isOverdue(task.endDate)
                                          ? Colors.red
                                          : Colors.grey.shade300,
                                      fontWeight: isOverdue(task.endDate)
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                                ),
                              ],
                            ),
                            trailing:
                            Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ],

            // Upcoming Tasks Section
            if (upcomingTasks.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Upcoming Tasks",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: upcomingTasks.length,
                itemBuilder: (context, index) {
                  final task = upcomingTasks[index];
                  return Stack(
                    children: [
                      // Wave background animation
                      SizedBox(
                        height: 80,
                        child: WaveWidget(
                          config: CustomConfig(
                            gradients: _getWaveGradients(task.priority),
                            durations: [8000, 7000],
                            //heightPercentages: _getWaveHeightPercentages(tasks.length),
                            heightPercentages: [0.20, 0.23],
                            blur:
                            const MaskFilter.blur(BlurStyle.solid, 5),
                          ),
                          waveAmplitude: 17,
                          size: const Size(
                              double.infinity, double.infinity),
                        ),
                      ),
                      // ListTile with transparency to show wave animation
                      Padding(
                        padding: EdgeInsets.only(bottom: 1),
                        child: Slidable(
                          key: ValueKey(tasks[index]),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TaskScreen(
                                                mode: Mode.Edit,
                                                taskModel: task,
                                              )));
                                },
                                backgroundColor: Colors.blue,
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                              SlidableAction(
                                onPressed: (_) {
                                  taskProvider.deleteTask(task.id);
                                },
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: ListTile(
                            minTileHeight: 80,
                            leading: task.isApproachingDeadline
                                ? Icon(Icons.warning,
                                color: Colors.orange)
                                : null,
                            title: Text(
                              task.title,
                              style: TextStyle(
                                color: task.isApproachingDeadline
                                    ? Colors.orange
                                    : Colors.black,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.description,
                                  style: TextStyle(
                                    fontStyle: isOverdue(task.endDate)
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
                                Text(
                                  'Due: ${task.endDate.day}-${task.endDate.month}-${task.endDate.year}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            trailing: Icon(
                              Icons.check_circle,
                              color: task.isApproachingDeadline
                                  ? Colors.orange
                                  : Colors.green,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      )
          : Center(
        child: Lottie.asset('assets/nodata.json'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          taskProvider.fnClearDatas();

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TaskScreen(
                    mode: Mode.Add,
                  )));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  bool isOverdue(DateTime endDate) {
    final currentDate = DateTime.now();
    return !endDate.isAtSameMomentAs(currentDate) &&
        endDate.isBefore(currentDate);
  }

  List<List<Color>> _getWaveGradients(taskPriority) {
    switch (taskPriority) {
      case "High":
        return [
          [Colors.red.withOpacity(0.5), Colors.redAccent.withOpacity(0.5)],
          [
            Colors.redAccent.withOpacity(0.5),
            Colors.deepOrange.withOpacity(0.5)
          ],
        ];
      case "Medium":
        return [
          [Colors.blue.withOpacity(0.5), Colors.blueAccent.withOpacity(0.5)],
          [Colors.lightBlue.withOpacity(0.5), Colors.cyan.withOpacity(0.5)],
        ];
      case "Low":
        return [
          [Colors.green.withOpacity(0.5), Colors.lightGreen.withOpacity(0.5)],
          [Colors.teal.withOpacity(0.5), Colors.greenAccent.withOpacity(0.5)],
        ];
      default:
        return [
          [Colors.grey.withOpacity(0.5), Colors.blueGrey.withOpacity(0.5)],
          [Colors.grey.withOpacity(0.5), Colors.blueGrey.withOpacity(0.5)],
        ];
    }
  }
}
