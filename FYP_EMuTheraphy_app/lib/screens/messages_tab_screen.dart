import 'package:flutter/material.dart';

import '/colors.dart';

class MessageTab extends StatefulWidget {
  const MessageTab({Key? key}) : super(key: key);

  @override
  State<MessageTab> createState() => _MessageTabState();
}

class _MessageTabState extends State<MessageTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Text("Messages", style: TextStyle(fontSize: 22, color: mainFontColor, fontWeight: FontWeight.bold,),)
                ),
              ),
              Flexible(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    ListTile(
                      leading: Icon(Icons.tag_faces_outlined),
                      title: Text("Dr. Ajith"),
                      subtitle: Text("Want to contact"),
                      trailing: Text("3.30 A.M."),
                    ),
                    ListTile(
                      leading: Icon(Icons.tag_faces_outlined),
                      title: Text("Dr. Ajith"),
                      subtitle: Text("Want to contact"),
                      trailing: Text("3.30 A.M>"),
                    )
                  ],
                ),
              )
            ],
          ),
    );
  }
}
