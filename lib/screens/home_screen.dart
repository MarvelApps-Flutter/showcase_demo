import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:realtime_database_app/screens/add_task_screen.dart';
import 'package:realtime_database_app/utils/app_text_styles.dart';
import 'package:realtime_database_app/utils/trapezium_clipper_decoration.dart';

class HomeScreenPage extends StatefulWidget {
  final FirebaseAnalytics? analytics;
  final FirebaseAnalyticsObserver? observer;
  const HomeScreenPage({Key? key, this.analytics, this.observer})
      : super(key: key);

  @override
  State<HomeScreenPage> createState() => _MyHomeScreenPageState();
}

class _MyHomeScreenPageState extends State<HomeScreenPage> {
  final referenceDatabase = FirebaseDatabase.instance.ref().child('Task Lists');
  Query? query;

  void _init() async{
    FirebaseMessaging.instance.getInitialMessage();
    var token = await FirebaseMessaging.instance.getToken();
    print("token: " + token!);
  }
  @override
  void initState() {

    query = FirebaseDatabase.instance
        .ref()
        .child('Task Lists')
        .orderByChild('assignee');
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: floatingActionButton(),
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
          task['key'] = snapshot.key;
          return buildItem(task: task);
        },
      ),
    );
  }

  Future<void> _sendAnalyticsForCreate() async {
    await widget.analytics!
        .logEvent(name: 'Add', parameters: {'add': 'add_task'});
  }

  Future<void> _sendAnalyticsThroughView() async {
    await widget.analytics!
        .logEvent(name: 'View', parameters: {'view': 'view_task'});
  }

  Future<void> _sendAnalyticsThroughEdit() async {
    await widget.analytics!
        .logEvent(name: 'Edit', parameters: {'edit': 'edit_task'});
  }

  Future<void> _sendAnalyticsThroughDelete() async {
    await widget.analytics!
        .logEvent(name: 'Delete', parameters: {'delete': 'delete_task'});
  }

  Widget floatingActionButton() {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF007cff),
      onPressed: () {
        _sendAnalyticsForCreate();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) {
            return AddTaskScreen(
              isViewMode: false,
              analytics: widget.analytics,
              observer: widget.observer,
            );
          }),
        );
      },
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  Widget buildItem({Map? task}) {
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
                        image: AssetImage("assets/images/display.jpg"),
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
                          "${task!['assignee']!}".replaceFirst(
                              task['assignee'][0],
                              task['assignee'][0].toUpperCase()),
                          style: AppTextStyles.boldColoredTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                        ),
                      ),
                      buildCrud(task),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "${task['contact_number']!}",
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
                          "${task['email']!}",
                          style: AppTextStyles.lightTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 170,
                    child: Text(
                      "${task['task_description']!}",
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
                        children: [trapeziumClippers(context, task['date'])],
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

  Widget buildCrud(Map? task) {
    return Container(
      alignment: Alignment.bottomRight,
      child: InkResponse(
        onTap: () {},
        child: PopupMenuButton(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Image.asset(
              "assets/images/bullet.png",
              height: 20,
              width: 24,
            ),
          ),
          onSelected: (choose) async {
            if (choose == "View") {
              _sendAnalyticsThroughView();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddTaskScreen(
                            taskKey: task!['key'],
                            isViewMode: true,
                            analytics: widget.analytics,
                            observer: widget.observer,
                          )));
            } else if (choose == "Edit") {
              _sendAnalyticsThroughEdit();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddTaskScreen(
                            taskKey: task!['key'],
                            isViewMode: false,
                            analytics: widget.analytics,
                            observer: widget.observer,
                          )));
            } else if (choose == "Delete") {
              _sendAnalyticsThroughDelete();
              _showDeleteDialog(contact: task);
            }
          },
          itemBuilder: (context) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem(
                  value: "View",
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(
                          Icons.remove_red_eye,
                          size: 17,
                        ),
                      ),
                      Text('View')
                    ],
                  )),
              PopupMenuItem(
                  value: "Edit",
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(
                          Icons.edit,
                          size: 17,
                        ),
                      ),
                      Text('Edit')
                    ],
                  )),
              PopupMenuItem(
                  value: "Delete",
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(
                          Icons.delete,
                          size: 17,
                        ),
                      ),
                      Text('Delete')
                    ],
                  ))
            ];
          },
        ),
      ),
    );
  }

  _showDeleteDialog({Map? contact}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Delete ${contact!['assignee']}',
              style: AppTextStyles.mediumTextStyle,
            ),
            content: const Text(
              'Are you sure you want to delete?',
              style: AppTextStyles.lightTextStyle,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: AppTextStyles.regularForSmallTextStyle,
                  )),
              TextButton(
                  onPressed: () {
                    referenceDatabase
                        .child(contact['key'])
                        .remove()
                        .whenComplete(() => Navigator.pop(context));
                  },
                  child: const Text(
                    'Delete',
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
        "Task Manager",
        style: AppTextStyles.regularForLargeTextStyle,
      ),
      leading: IconButton(
        padding: const EdgeInsets.only(left: 10),
        onPressed: () {},
        icon: const Icon(Icons.menu),
        iconSize: 24,
        color: Colors.black,
      ),
    );
  }
}
