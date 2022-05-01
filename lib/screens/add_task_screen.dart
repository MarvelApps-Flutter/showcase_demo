import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realtime_database_app/constants/app_constants.dart';
import 'package:realtime_database_app/mixins/validate_mixin.dart';
import 'package:realtime_database_app/share/reusable_widgets.dart';
import 'package:realtime_database_app/utils/app_config.dart';
import 'package:realtime_database_app/utils/app_text_styles.dart';

class AddTaskScreen extends StatefulWidget {
  final String? taskKey;
  final bool? isViewMode;
  const AddTaskScreen(
      {Key? key, this.taskKey, this.isViewMode,
      })
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
  Map<int, Color> color = {
    50: const Color(0xFF007cff),
    100: const Color(0xFF007cff),
    200: const Color(0xFF007cff),
    300: const Color(0xFF007cff),
    400: const Color(0xFF007cff),
    500: const Color(0xFF007cff),
    600: const Color(0xFF007cff),
    700: const Color(0xFF007cff),
    800: const Color(0xFF007cff),
    900: const Color(0xFF007cff),
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
            dialogBackgroundColor: Colors.white,
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
    final DateFormat formatter = DateFormat(AppConstants.dateFormatString);
    final String formatted = formatter.format(_currentDate);
    _dueDateController!.value = TextEditingValue(text: formatted);
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    formGlobalKey = GlobalKey<FormState>();
    _taskController = TextEditingController();
    _assigneeController = TextEditingController();
    _emailController = TextEditingController();
    _contactNumberController = TextEditingController();
    _dueDateController = TextEditingController();
    referenceDatabase = FirebaseDatabase.instance;
    formatDate();
    reference = referenceDatabase.ref().child(AppConstants.taskListsString);
    if (widget.taskKey != null) {
      getTaskDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    appC = AppConfig(context);
    return Scaffold(backgroundColor: Colors.white, body: buildBody());
  }

  Widget buildBody() {
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
                      image: AssetImage(AppConstants.headerAssetImageString),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                buildSizedBoxWidget(10),
                Text(
                    (widget.isViewMode) == true
                        ? AppConstants.bigViewTaskString
                        : (widget.isViewMode == false && widget.taskKey != null)
                            ? AppConstants.bigEditTaskString
                            : AppConstants.bigCreateTaskString,
                    style: AppTextStyles.blackTextStyle),
                buildSizedBoxWidget(13),
                const Text(
                  AppConstants.enterDetailsString,
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
                    ? buildButtonWidget(
                        context,
                        widget.taskKey != null
                            ? AppConstants.capitalUpdateString
                            : AppConstants.capitalCreateString, () {
                        if (formGlobalKey!.currentState!.validate()) {
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
        labelText: AppConstants.whatNeedsToDoneString,
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (task) {
        if (task!.isNotEmpty) {
          return null;
        } else {
          return AppConstants.enterTaskString;
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
        labelText: AppConstants.enterAssigneeString,
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (name) {
        if (name!.isNotEmpty) {
          return null;
        } else {
          return AppConstants.enterAssigneeString;
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
        labelText: AppConstants.enterEmailString,
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (email) {
        if (isEmailValid(email!)) {
          return null;
        } else {
          return AppConstants.enterValidEmailString;
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
        labelText: AppConstants.enterContactNumberString,
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (number) {
        if (isPhoneNumberValid(number!)) {
          return null;
        } else {
          return AppConstants.enterValidContactNumberString;
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
              labelText: AppConstants.enterDueDateString,
              labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
              filled: true,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              fillColor: Colors.grey.withOpacity(0.3),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 0, style: BorderStyle.none)),
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
              labelText: AppConstants.enterDueDateString,
              labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
              filled: true,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              fillColor: Colors.grey.withOpacity(0.3),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 0, style: BorderStyle.none)),
            ),
          );
  }

  void saveTask() {
    Map<String, String> data = {
      AppConstants.taskDescriptionString: _taskController!.text.toString().trim(),
      AppConstants.assigneeString: _assigneeController!.text.toString().trim(),
      AppConstants.emailString: _emailController!.text.toString().trim(),
      AppConstants.contactNumberString: _contactNumberController!.text.toString().trim(),
      AppConstants.dateString : _dueDateController!.text.toString().trim()
    };

    reference.push().set(data).then((value) {
      Navigator.pop(context);
    });
  }

  getTaskDetail() async {
    DatabaseEvent snapshot = await reference!.child(widget.taskKey).once();
    Map taskData = snapshot.snapshot.value as Map;
    _assigneeController!.text = taskData[AppConstants.assigneeString];
    _contactNumberController!.text = taskData[AppConstants.contactNumberString];
    _emailController!.text = taskData[AppConstants.emailString];
    _taskController!.text = taskData[AppConstants.taskDescriptionString];
    _dueDateController!.text = taskData[AppConstants.dateString];
  }

  void updateTask() {
    Map<String, String> data = {
      AppConstants.taskDescriptionString: _taskController!.text.toString().trim(),
      AppConstants.assigneeString: _assigneeController!.text.toString().trim(),
      AppConstants.emailString : _emailController!.text.toString().trim(),
      AppConstants.contactNumberString: _contactNumberController!.text.toString().trim(),
      AppConstants.dateString : _dueDateController!.text.toString().trim()
    };

    reference!.child(widget.taskKey!).update(data).then((value) {
      Navigator.pop(context);
    });
  }
}
