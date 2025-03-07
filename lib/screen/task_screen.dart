import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/model/task_model.dart';
import 'package:taskmanager/widgets/common.dart';
import 'package:taskmanager/widgets/common_button.dart';
import 'package:taskmanager/widgets/common_textfield.dart';
import 'package:taskmanager/widgets/custom_date_picker.dart';

import '../providers/task_provider.dart';
import '../styles/colors.dart';
import '../widgets/commonAppbar.dart';
enum Mode {Add,Edit}
class TaskScreen extends StatefulWidget {
  final Mode mode;
  final TaskModel? taskModel;

  const TaskScreen({super.key,required this.mode,this.taskModel});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  TextEditingController txtTitle=TextEditingController();
  TextEditingController txtDescription=TextEditingController();
  @override
  void dispose() {
    txtTitle.dispose();
    txtDescription.dispose();
    // context.read<TaskProvider>().objectBox.close();

    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState

    if(widget.mode==Mode.Edit){
      Future.microtask(() {
        Provider.of<TaskProvider>(context, listen: false).updateData(widget.mode,widget.taskModel!);
      });
      txtDescription.text= widget.taskModel!.description;
      txtTitle.text= widget.taskModel!.title;
    }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);


    return Scaffold(
      appBar: CommonAppbar(
        isShowSync: false,
        title: widget.mode==Mode.Edit?"Update Task" :"Add Task",
        showBackButton: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Form(
            key: taskProvider.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tcnBody(
                  " Title",
                  txtColor,
                ),
                gapHC(1),
                CommonTextField(
                  onChanged: taskProvider.setTitle,
                  hintText: 'title',
                  txtController: txtTitle,
                  prefixIconColor: Colors.grey.shade600,
                  txtSize: 12,
                  fnClear: () {
                    txtTitle.clear();
                  },
                  validate: (value) {
                    if (value.isEmpty || value == null) {
                      return "Please Enter a Value";
                    } else {
                      return null;
                    }
                  },
                ),
                gapHC(10),
                tcnBody(
                  " Description",
                  txtColor,
                ),
                gapHC(1),
                CommonTextField(
                  hintText: 'Description',
                  onChanged: taskProvider.setDescription,
                  txtController: txtDescription,
                  prefixIconColor: Colors.grey.shade600,
                  txtSize: 12,
                  maxline: 3,
                  fnClear: () {
                    txtDescription.clear();
                  },
                  validate: (value) {
                    if (value.isEmpty || value == null) {
                      return "Please Enter a Value";
                    } else {
                      return null;
                    }
                  },
                ),
                gapHC(10),
                tcnBody(
                  " Priority",
                  txtColor,
                ),
                gapHC(1),
                Center(
                  child: DropdownButtonFormField<String>(
                    value: taskProvider.selectedPriority,
                    items: taskProvider.priority.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        taskProvider.setSelectedPriority(newValue);
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                gapHC(10),
                tcnBody(
                  " Status",
                  txtColor,
                ),
                gapHC(1),
                Center(
                  child: DropdownButtonFormField<String>(
                    value: taskProvider.selectedStatus,
                    items: taskProvider.statuss.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        taskProvider.setSelectedStatus(newValue);
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                gapHC(10),
                tcnBody(
                  " End Date",
                  txtColor,
                ),
                gapHC(1),
                CustomDatePicker()
              ],
            ),
          ),
        ),
      ),
      persistentFooterButtons: [
        CommonButton(
          btnName: widget.mode==Mode.Edit? "Update":"Save",
          btnColor: Colors.black,
          txtColor: Colors.white,
          onTap: () {
            if (taskProvider.validateForm()) {
              if(widget.mode==Mode.Edit){
                final task = TaskModel(
                    id: widget.taskModel!.id,
                    title: txtTitle.text,
                    description: txtDescription.text,
                    priority: taskProvider.selectedPriority,
                    status: taskProvider.selectedStatus,
                    endDate: taskProvider.endDate!);


                taskProvider.updateTask(task);
              }else{
                taskProvider.fnSave();
              }

              Navigator.pop(context);

              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('Form submitted successfully!')),
              // );
            }
          },
        )
      ],
    );
  }

  void setEditedDatas() {


  }
}
