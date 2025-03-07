import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/providers/task_provider.dart';
import 'package:taskmanager/widgets/common.dart';

import '../db/objBox/objectbox.dart';
import '../providers/connectivity_provider.dart';


class CommonAppbar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final bool showBackButton;
  final bool isShowSync;
  final bool ?home;
  final List<Widget>? actions;

  const CommonAppbar({    super.key,
    required this.title,
    this.home,
    this.showBackButton = true,
    this.actions, required this.isShowSync,});

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    return AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: showBackButton
          ? IconButton(
        icon:  Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: () => Navigator.pop(context),
      )
          : null,
        actions: [

          // isShowSync && connectivityProvider.isOnline?Bounce(
          //   duration: Duration(milliseconds: 110),
          //   onPressed: ()async{
          //     final objectBox = await ObjectBox.create();
          //     SyncService(objectBox);
          //
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.only(top: 12),
          //     child: Container(
          //       padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
          //       decoration: boxDecoration(Colors.white, 20),
          //       child: Text("Sync",style: TextStyle(
          //           color: Colors.black,
          //           fontWeight: FontWeight.bold
          //       ),),
          //     ),
          //   ),
          // ):SizedBox(),

          home==true? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.file_upload,
                color: Colors.white,),

                onPressed: () async {
                //  await taskProvider.exportTasks();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tasks exported successfully!')),
                  );
                },
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.file_download,
                    color: Colors.white),
                onPressed: () async {
                 // await taskProvider.importTasks();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tasks imported successfully!')),
                  );
                },
              ),
            ],
          ):SizedBox(),
          connectivityProvider.isOnline?Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.circle,
                color: Colors.green,),
              Text("Online",style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),)
            ],
          ):
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.circle,
                color: Colors.red,),
              Text("Offline",style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),)
            ],
          ),


        ],
      );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
