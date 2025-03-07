import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/db/objBox/objectbox.dart';
import 'package:taskmanager/model/task_model.dart';
import 'package:taskmanager/providers/connectivity_provider.dart';
import 'package:taskmanager/providers/task_provider.dart';
import 'package:taskmanager/screen/home_screen.dart';
import 'package:taskmanager/screen/task_screen.dart';

import 'firebase_options.dart';
import 'objectbox.g.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final objectBox = await ObjectBox.create();

  runApp( MultiProvider(providers: [

      ChangeNotifierProvider(create: (_)=>ConnectivityProvider()),
      ChangeNotifierProvider(create: (_)=>TaskProvider(objectBox.store.box<TaskModel>())),



  ],
  child:MyApp() ,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:  HomeScreen(),

    );
  }
}


