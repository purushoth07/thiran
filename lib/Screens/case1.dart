import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:thiran/common/common_widgets.dart';
import 'package:thiran/controllers/appload_controller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thiran/helper/case1/database_helper.dart';

class UseCase1 extends StatefulWidget {
  const UseCase1({Key? key}) : super(key: key);

  @override
  _UseCase1State createState() => _UseCase1State();
}

class _UseCase1State extends State<UseCase1> {

  final AppLoadController appLoadController =
  Get.put(AppLoadController.getInstance(), permanent: true);

  List<Map<String, dynamic>> tasks = [];

  TextEditingController taskController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController personController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var dt = DateTime.now();
    timeController.text = '${dt.day}/${dt.month}/${dt.year}  ${dt.hour}:${dt.minute}:${dt.second}';
    _loadTasks();
  }

  void _loadTasks() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(DatabaseHelper.table);
    setState(() {
      tasks = rows;
    });
  }

  void _addTask(BuildContext context) async {
    final now = DateTime.now();
    final formattedDate = DateFormat.yMd().add_jm().format(now);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        String? name;
        String? status;
        String? person;

        return StatefulBuilder(builder: (context, setState) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      heading(text: 'Adding to Sqflite'),
                      const SizedBox(height: 15),
                      PrimaryInputText(hintText: 'Task',
                        controller: taskController,
                        onValidate: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please enter task detail';
                          }
                          return null;
                        },),
                      const SizedBox(height: 15),
                      PrimaryInputText(hintText: 'Update Status',
                        controller: statusController,
                        maxLines: 2,
                        onValidate: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please enter status details';
                          }
                          return null;
                        },),
                      const SizedBox(height: 15),
                      PrimaryInputText(hintText: 'Person',
                        // controller: emailController,
                        controller: personController,
                        onValidate: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please enter person controller';
                          }
                          return null;
                        },),
                      const SizedBox(height: 15),
                      PrimaryInputText(hintText: 'Time',
                        controller: timeController,
                        onValidate: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please enter email address';
                          }
                          return null;
                        },),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: GestureDetector(
              onTap: () async{
                if(formKey.currentState!.validate()){
                  final task = {
                    DatabaseHelper.columnName: taskController.text,
                    DatabaseHelper.columnStatus: statusController.text,
                    DatabaseHelper.columnPerson: personController.text,
                    DatabaseHelper.columnTime: timeController.text,
                  };
                  await DatabaseHelper.instance.insert(task);
                  taskController.clear();
                  statusController.clear();
                  personController.clear();
                  timeController.clear();
                  Navigator.pop(context);
                  _loadTasks();
                }
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 1,
                decoration: const BoxDecoration(
                    color: Colors.cyan
                ),
                child: Center(child: heading(text: 'Submit', color: Colors.white)),
              ),
            ),
          );
        });
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appLoadController.themeColor,
        foregroundColor: Colors.black,
        title: heading(text: 'UseCase 1'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task[DatabaseHelper.columnName]),
            subtitle: Text(task[DatabaseHelper.columnStatus]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context),
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}
