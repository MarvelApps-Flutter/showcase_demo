import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:realtime_database_app/constants/app_constants.dart';
import 'package:realtime_database_app/screens/add_task_screen.dart';
import 'package:realtime_database_app/utils/app_text_styles.dart';
import 'package:realtime_database_app/utils/trapezium_clipper_decoration.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreenPage> createState() => _MyHomeScreenPageState();
}

class _MyHomeScreenPageState extends State<HomeScreenPage> {
  var referenceDatabase;
  Query? query;
  final GlobalKey _one = GlobalKey(debugLabel: '_one');
  final GlobalKey _two = GlobalKey(debugLabel: '_two');
  final GlobalKey _three = GlobalKey(debugLabel: '_three');
  BuildContext? myContext;
  void init() async {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(myContext!).startShowCase([_one,_two,_three]));
    query = FirebaseDatabase.instance
        .ref()
        .child(AppConstants.taskListsString)
        .orderByChild(AppConstants.assigneeString);
    referenceDatabase =
        FirebaseDatabase.instance.ref().child(AppConstants.taskListsString);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          myContext = context;
          return Scaffold(
            appBar: buildAppBar(),
            body: buildBody(),
            floatingActionButton: floatingActionButton(),
          );
        },
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: FirebaseAnimatedList(
        shrinkWrap: true,
        query: query!,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map task = snapshot.value as Map;
          task[AppConstants.keyString] = snapshot.key;
          return buildItem(task: task,position: index);
        },
      ),
    );
  }

  Widget floatingActionButton() {
    return Showcase(
      overlayPadding: EdgeInsets.all(3),
      description: "Add your task by pressing it",
      title: "Add task",
      key: _one,
      child: FloatingActionButton(
        backgroundColor: const Color(0xFF007cff),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return AddTaskScreen(
                isViewMode: false,
              );
            }),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget buildItem({Map? task,int? position}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 8,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                alignment: Alignment.topLeft,
                height: 120.0,
                width: 100.0,
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5.0)
                    ],
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    image: DecorationImage(
                        image: AssetImage(AppConstants.displayAssetImageString),
                        fit: BoxFit.fill)),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(top: 7.0, left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "${task![AppConstants.assigneeString]!}".replaceFirst(
                              task[AppConstants.assigneeString][0],
                              task[AppConstants.assigneeString][0]
                                  .toUpperCase()),
                          style: AppTextStyles.boldColoredTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      buildCrud(task,position),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "${task[AppConstants.contactNumberString]!}",
                          style: AppTextStyles.lightTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "${task[AppConstants.emailString]!}",
                          style: AppTextStyles.lightTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   width: 170,
                  //   child: Text(
                  //     "${task[AppConstants.taskDescriptionString]!}",
                  //     overflow: TextOverflow.ellipsis,
                  //     style: AppTextStyles.lightTextStyle,
                  //     maxLines: 1,
                  //   ),
                  // ),
                  position == 1 ?
                  Showcase(
                     overlayPadding: EdgeInsets.all(1),
                      description: "This shows task description on a particular date",
                      title: "Task",
                      key: _two,
                    child: SizedBox(
                      width: 170,
                      child: Text(
                        "${task[AppConstants.taskDescriptionString]!}",
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.lightTextStyle,
                        maxLines: 1,
                      ),
                    ),
                  ) : SizedBox(
                      width: 170,
                      child: Text(
                        "${task[AppConstants.taskDescriptionString]!}",
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.lightTextStyle,
                        maxLines: 1,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          trapeziumClippers(
                              context, task[AppConstants.dateString])
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget buildCrud(Map? task,int? position) {
    return Container(
      alignment: Alignment.bottomRight,
      child: InkResponse(
        onTap: () {},
        child: 
        position == 2 ?
        Showcase(
          overlayPadding: EdgeInsets.all(2),
          description: "Task operations which you can perform like view ,edit and delete",
          title: "Task operations",
          key: _three,
          child: PopupMenuButton(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Image.asset(
                AppConstants.bulletAssetImageString,
                height: 20,
                width: 24,
              ),
            ),
            onSelected: (choose) async {
              if (choose == AppConstants.viewPopUpString) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddTaskScreen(
                              taskKey: task![AppConstants.keyString],
                              isViewMode: true,
                            )));
              } else if (choose == AppConstants.editPopUpString) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddTaskScreen(
                              taskKey: task![AppConstants.keyString],
                              isViewMode: false,
                            )));
              } else if (choose == AppConstants.deletePopUpString) {
                _showDeleteDialog(contact: task);
              }
            },
            itemBuilder: (context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem(
                    value: AppConstants.viewPopUpString,
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                          child: Icon(
                            Icons.remove_red_eye,
                            size: 17,
                          ),
                        ),
                        Text(AppConstants.viewPopUpString)
                      ],
                    )),
                PopupMenuItem(
                    value: AppConstants.editPopUpString,
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                          child: Icon(
                            Icons.edit,
                            size: 17,
                          ),
                        ),
                        Text(AppConstants.editPopUpString)
                      ],
                    )),
                PopupMenuItem(
                    value: AppConstants.deletePopUpString,
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                          child: Icon(
                            Icons.delete,
                            size: 17,
                          ),
                        ),
                        Text(AppConstants.deletePopUpString)
                      ],
                    ))
              ];
            },
          ),
        )
        : PopupMenuButton(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Image.asset(
                AppConstants.bulletAssetImageString,
                height: 20,
                width: 24,
              ),
            ),
            onSelected: (choose) async {
              if (choose == AppConstants.viewPopUpString) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddTaskScreen(
                              taskKey: task![AppConstants.keyString],
                              isViewMode: true,
                            )));
              } else if (choose == AppConstants.editPopUpString) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddTaskScreen(
                              taskKey: task![AppConstants.keyString],
                              isViewMode: false,
                            )));
              } else if (choose == AppConstants.deletePopUpString) {
                _showDeleteDialog(contact: task);
              }
            },
            itemBuilder: (context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem(
                    value: AppConstants.viewPopUpString,
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                          child: Icon(
                            Icons.remove_red_eye,
                            size: 17,
                          ),
                        ),
                        Text(AppConstants.viewPopUpString)
                      ],
                    )),
                PopupMenuItem(
                    value: AppConstants.editPopUpString,
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                          child: Icon(
                            Icons.edit,
                            size: 17,
                          ),
                        ),
                        Text(AppConstants.editPopUpString)
                      ],
                    )),
                PopupMenuItem(
                    value: AppConstants.deletePopUpString,
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                          child: Icon(
                            Icons.delete,
                            size: 17,
                          ),
                        ),
                        Text(AppConstants.deletePopUpString)
                      ],
                    ))
              ];
            },
          )
        ,
      ),
    );
  }

  _showDeleteDialog({Map? contact}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              '${AppConstants.deleteTextString} ${contact![AppConstants.assigneeString]}',
              style: AppTextStyles.mediumTextStyle,
            ),
            content: const Text(
              AppConstants.deleteConfirmationMessageString,
              style: AppTextStyles.lightTextStyle,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    AppConstants.cancelTextString,
                    style: AppTextStyles.regularForSmallTextStyle,
                  )),
              TextButton(
                  onPressed: () {
                    referenceDatabase
                        .child(contact[AppConstants.keyString])
                        .remove()
                        .whenComplete(() => Navigator.pop(context));
                  },
                  child: const Text(
                    AppConstants.deleteTextString,
                    style: AppTextStyles.regularForSmallTextStyle,
                  ))
            ],
          );
        });
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      title: const Text(
        AppConstants.homeTitleString,
        style: AppTextStyles.regularForLargeTextStyle,
      ),
    );
  }
}
