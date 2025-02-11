import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactList extends StatelessWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact List"),
        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.search),
          )
        ],
      ),
      body: Text("List")
    );
  }
}
