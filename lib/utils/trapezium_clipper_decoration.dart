import 'package:flutter/material.dart';
import 'package:realtime_database_app/utils/trapezium_clipper.dart';

Widget trapeziumClippers(BuildContext context, String date) {
  return ClipPath(
    clipper: TrapeziumClipper(),
    child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
                colors: [Color(0xFF007cff), Color(0xFF2d8ff6)],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
              )
           ,
      ),
      padding: const EdgeInsets.fromLTRB(3, 4, 8.0, 2),
      width: MediaQuery.of(context).size.width * 1.7 / 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 3 / 6),
            child: Text(
             date,
              softWrap: true,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ),
  );
}
