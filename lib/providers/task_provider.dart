import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:taskmanager/model/task_model.dart';

import '../db/sqflte.dart';
import '../screen/task_screen.dart';



class TaskProvider with ChangeNotifier {
  final Box<TaskModel> taskBox;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription? connectivitySubscription;

  TaskProvider(this.taskBox) {
    _initSync();
  }

  void _initSync() {
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        syncLocalToFirestore();
      }
    });
  }

  DateTime _endDate = DateTime.now();
  DateTime? get endDate => _endDate;
  // Setter for selected date
  void setSelectedDate(DateTime date) {
    _endDate = date;
    notifyListeners();  // Notify listeners about the date change
  }
  String get formattedDate {
    return '${_endDate.day}-${_endDate.month}-${_endDate.year}';
  }










  bool validateForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();  // Save form data if valid
      return true;
    }
    return false;
  }
  final List<String> _priority = ['High', 'Medium', 'Low'];
  String _selectedPriority='High';
  List<String> get priority => _priority;
  String get selectedPriority => _selectedPriority;
  void setSelectedPriority(String value) {
    _selectedPriority = value;
    notifyListeners();  // Notify listeners when the selection changes
  }
  final List<String> _status = ['Pending', 'Completed'];
  String _selectedStatus='Pending';
  List<String> get statuss => _status;
  String get selectedStatus => _selectedStatus;
  void setSelectedStatus(String value) {
    _selectedStatus = value;
    notifyListeners();  // Notify listeners when the selection changes
  }

// Fields
  String _title = '';
  String _description = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Getters
  String get title => _title;
  String get description => _description;
  GlobalKey<FormState> get formKey => _formKey;
  // Setters
  void setTitle(String value) {
    _title = value;
    notifyListeners();
  }
  void setDescription(String value) {
    _description = value;
    notifyListeners();
  }

  // Get overdue tasks
  List<TaskModel> get overdueTasks {
    return tasks.where((task) => task.isOverdue).toList();
  }

  // Get tasks with approaching deadlines
  List<TaskModel> get upcomingTasks {
    return tasks.where((task) => !task.isOverdue).toList();
  }
  fnSave(){
    final taskm = TaskModel(
        title: _title,
        description: _description,
        priority: _selectedPriority,
        status: _selectedStatus,
        endDate: _endDate);
    addTask(taskm);


  }

  List<TaskModel> get tasks => taskBox.getAll();

  /// Add a new task locally and sync when online
  Future<void> addTask(TaskModel task) async {
    taskBox.put(task);
    if (await _isOnline()) {
      if(task.status=="Completed"){
        await firestore.collection('tasks').doc(task.id.toString()).set(task.toMap());
      }

    }
    notifyListeners();
  }
  updateData(Mode mode,TaskModel taskModel){
    if(mode == Mode.Edit) {
      setTitle(taskModel.title);
      setDescription(taskModel.description);
      setSelectedPriority(taskModel.priority);
      setSelectedStatus(taskModel.status);
      setSelectedDate(taskModel.endDate);
    }
  }
  /// Update a task locally and sync with Firestore
  Future<void> updateTask(TaskModel task) async {
    taskBox.put(task);
    if (await _isOnline()) {
      if(task.status=="Completed"){
        await firestore.collection('tasks').doc(task.id.toString()).update(task.toMap());
      }

    }
    notifyListeners();
  }

  /// Delete task locally and from Firestore when online
  Future<void> deleteTask(int id) async {
    taskBox.remove(id);
    if (await _isOnline()) {
      await firestore.collection('tasks').doc(id.toString()).delete();
    }
    notifyListeners();
  }

  /// Sync local ObjectBox data with Firestore when online
  Future<void> syncLocalToFirestore() async {
    final localTasks = taskBox.getAll();
    for (var task in localTasks) {
      if(task.status =="Completed"){
        await firestore.collection('tasks').doc(task.id.toString()).set(task.toMap());

      }
          }
  }

  /// Sync Firestore data to ObjectBox (if new)
  Future<void> syncFirestoreToLocal() async {
    final snapshot = await firestore.collection('tasks').get();
    for (var doc in snapshot.docs) {
      final task = TaskModel.fromMap(doc.data());
      if (taskBox.get(task.id) == null) {
        taskBox.put(task);
      }
    }
  }

  /// Check internet connectivity
  Future<bool> _isOnline() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    super.dispose();
  }
  // Export tasks to SQLite
  Future<void> exportTasks() async {
    await SQLiteHelper.exportTasksToSQLite(tasks);
    final exportPath = await SQLiteHelper.exportDatabaseFile();
    if (exportPath != null) {
      print('Tasks exported to: $exportPath');
    } else {
      print('Export failed!');
    }
  }
  List<TaskModel> _tasks = [];
  fnClearDatas(){

    setDescription("");
    setTitle("");
    setSelectedPriority("High");
    setSelectedStatus("Pending");
    setSelectedDate(DateTime.now());
  }
  List<TaskModel> get taskData => _tasks;
  // Import tasks from SQLite
  Future<void> importTasks() async {
    final importedTasks = await SQLiteHelper.importTasksFromSQLite();
    _tasks = importedTasks;
    notifyListeners();
    print('Tasks imported successfully!');
  }
}