import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realtime_database_app/mixins/validate_mixin.dart';
import 'package:realtime_database_app/share/reusable_widgets.dart';
import 'package:realtime_database_app/utils/app_config.dart';
import 'package:realtime_database_app/utils/app_text_styles.dart';

class AddTaskScreen extends StatefulWidget {
  final String? taskKey;
  final bool? isViewMode;
  final FirebaseAnalytics? analytics;
  final FirebaseAnalyticsObserver? observer;
  const AddTaskScreen({Key? key, this.taskKey, this.isViewMode, this.analytics, this.observer})
      : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen>
    with InputValidationMixin {
  late AppConfig appC;
  GlobalKey<FormState>? formGlobalKey;
  TextEditingController? _taskController;
  TextEditingController? _assigneeController;
  TextEditingController? _emailController;
  TextEditingController? _contactNumberController;
  TextEditingController? _dueDateController;
  var referenceDatabase;
  var reference;
  Map<int, Color> color =
  {
    50: const Color(0xFF007cff),
    100:const Color(0xFF007cff),
    200:const Color(0xFF007cff),
    300:const Color(0xFF007cff),
    400:const Color(0xFF007cff),
    500:const Color(0xFF007cff),
    600:const Color(0xFF007cff),
    700:const Color(0xFF007cff),
    800:const Color(0xFF007cff),
    900:const Color(0xFF007cff),
  };

  DateTime _currentDate = DateTime.now();
  Future _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: MaterialColor(0xFF007cff, color),
              primaryColorDark: const Color(0xFF007cff),
              accentColor: const Color(0xFF007cff),
            ),
            dialogBackgroundColor:Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _currentDate) {
      setState(() {
        _currentDate = picked;
        formatDate();
      });
    }
  }

  void formatDate() {
    final DateFormat formatter = DateFormat('dd/MMM/yyyy');
    final String formatted = formatter.format(_currentDate);
    _dueDateController!.value = TextEditingValue(text: formatted);
  }

  Future<void> _sendAnalytics() async{
    await widget.analytics!.logEvent(name: 'Create', parameters: {'create': 'add_task'});
  }

  Future<void> _setCurrentScreen() async{
    await widget.analytics!.setCurrentScreen(screenName: 'Add Task', screenClassOverride: "AddTask");
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init()
  {
    formGlobalKey = GlobalKey<FormState>();
    _taskController = TextEditingController();
    _assigneeController = TextEditingController();
    _emailController = TextEditingController();
    _contactNumberController = TextEditingController();
    _dueDateController = TextEditingController();
    referenceDatabase = FirebaseDatabase.instance;
    _setCurrentScreen();
    formatDate();
    reference = referenceDatabase.ref().child('Task Lists');
    if (widget.taskKey != null) {
      getTaskDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    appC = AppConfig(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: buildBody());
  }

  Widget buildBody()
  {
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: formGlobalKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: appC.rH(26),
                  width: appC.rW(60),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/header.jpg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                buildSizedBoxWidget(10),
                Text((widget.isViewMode) == true ? "View Task" : (widget.isViewMode == false && widget.taskKey != null) ? "Edit Task" : "Create Task", style: AppTextStyles.blackTextStyle),
                buildSizedBoxWidget(13),
                const Text(
                  "Please enter the details below to continue",
                  style: AppTextStyles.lightTextStyle,
                ),
                buildSizedBoxWidget(15),
                buildDueDateTextField(),
                buildSizedBoxWidget(10),
                buildAssigneeTextField(),
                buildSizedBoxWidget(10),
                buildEmailTextField(),
                buildSizedBoxWidget(10),
                buildContactNumberTextField(),
                buildSizedBoxWidget(10),
                buildTaskTextField(),
                buildSizedBoxWidget(15),
                widget.isViewMode == false
                    ? buildButtonWidget(context,
                    widget.taskKey != null ? "UPDATE" : "CREATE", () {
                      if (formGlobalKey!.currentState!.validate()) {
                        _sendAnalytics();
                        if (_emailController!.text
                            .toString()
                            .trim()
                            .length !=
                            0 &&
                            _taskController!.text
                                .toString()
                                .trim()
                                .length !=
                                0 &&
                            _assigneeController!.text
                                .toString()
                                .trim()
                                .length !=
                                0 &&
                            _contactNumberController!.text
                                .toString()
                                .trim()
                                .length !=
                                0) {
                          if (widget.taskKey != null) {
                            updateTask();
                          } else {
                            saveTask();
                            FirebaseInAppMessaging.instance.triggerEvent("custom_add");
                            FirebaseMessaging.instance.getInitialMessage();
                          }
                        }
                      }
                    })
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTaskTextField() {
    return TextFormField(
      controller: _taskController,
      cursorColor: Colors.black,
      readOnly: widget.isViewMode == true ? true : false,
      keyboardType: TextInputType.multiline,
      minLines: 3,
      maxLines: null,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.task,
          color: Colors.grey,
        ),
        labelText: "What needs to be done",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide:  BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (task) {
        if (task!.isNotEmpty) {
          return null;
        } else {
          return 'Enter Task';
        }
      },
    );
  }

  Widget buildAssigneeTextField() {
    return TextFormField(
      controller: _assigneeController,
      cursorColor: Colors.black,
      readOnly: widget.isViewMode == true ? true : false,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.person,
          color: Colors.grey,
        ),
        labelText: "Enter Assignee",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide:  BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (name) {
        if (name!.isNotEmpty) {
          return null;
        } else {
          return 'Enter Assignee';
        }
      },
    );
  }

  Widget buildEmailTextField() {
    return TextFormField(
      controller: _emailController,
      cursorColor: Colors.black,
      readOnly: widget.isViewMode == true ? true : false,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.mail,
          color: Colors.grey,
        ),
        labelText: "Enter Email",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide:  BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (email) {
        if (isEmailValid(email!)) {
          return null;
        } else {
          return 'Enter a valid email address';
        }
      },
    );
  }

  Widget buildContactNumberTextField() {
    return TextFormField(
      controller: _contactNumberController,
      cursorColor: Colors.black,
      readOnly: widget.isViewMode == true ? true : false,
      keyboardType: TextInputType.phone,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.phone,
          color: Colors.grey,
        ),
        labelText: "Enter Contact Number",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide:  BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (number) {
        if (isPhoneNumberValid(number!)) {
          return null;
        } else {
          return 'Enter a valid contact number';
        }
      },
    );
  }

  Widget buildDueDateTextField() {
    return widget.isViewMode == false
        ? TextFormField(
      controller: _dueDateController,
      onTap: () async {
        await _selectDueDate(context);
        FocusScope.of(context).requestFocus(FocusNode());
      },
      cursorColor: Colors.black,
      autofocus: false,
      readOnly: true,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.calendar_today,
          color: Colors.grey,
        ),
        labelText: "Enter Due Date",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide:
            BorderSide(width: 0, style: BorderStyle.none)),
      ),
    )
        : TextFormField(
      controller: _dueDateController,
      cursorColor: Colors.black,
      readOnly: true,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.calendar_today,
          color: Colors.grey,
        ),
        labelText: "Enter Due Date",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide:
            BorderSide(width: 0, style: BorderStyle.none)),
      ),
    );
  }

  void saveTask() {
    Map<String, String> data = {
      "task_description": _taskController!.text.toString().trim(),
      "assignee": _assigneeController!.text.toString().trim(),
      "email": _emailController!.text.toString().trim(),
      "contact_number": _contactNumberController!.text.toString().trim(),
      "date": _dueDateController!.text.toString().trim()
    };

    reference.push().set(data).then((value) {
      Navigator.pop(context);
    });
  }

  getTaskDetail() async {
    DatabaseEvent snapshot = await reference!.child(widget.taskKey).once();
    Map taskData = snapshot.snapshot.value as Map;
    _assigneeController!.text = taskData['assignee'];
    _contactNumberController!.text = taskData['contact_number'];
    _emailController!.text = taskData['email'];
    _taskController!.text = taskData['task_description'];
    _dueDateController!.text = taskData['date'];
  }

  void updateTask() {
    Map<String, String> data = {
      "task_description": _taskController!.text.toString().trim(),
      "assignee": _assigneeController!.text.toString().trim(),
      "email": _emailController!.text.toString().trim(),
      "contact_number": _contactNumberController!.text.toString().trim(),
      "date": _dueDateController!.text.toString().trim()
    };

    reference!.child(widget.taskKey!).update(data).then((value) {
      Navigator.pop(context);
    });
  }
}
