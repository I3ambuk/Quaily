import 'dart:math';

import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:quaily/src/features/friends/utils/contactListUtils.dart';

class ContactListWidget extends StatefulWidget {
  @override
  _ContactListWidgetState createState() => _ContactListWidgetState();
}

class _ContactListWidgetState extends State<ContactListWidget> {
  @override
  void initState() {
    super.initState();
    refreshContacts();
  }

  @override
  Widget build(Object context) {
    return SafeArea(
      child: ValueListenableBuilder<List<Contact>>(
        valueListenable: contactsNotifier,
        builder: (context, value, child) => ListView.builder(
          itemCount: contactsNotifier.value.length,
          itemBuilder: (BuildContext context, int index) {
            Contact? c = contactsNotifier.value.elementAt(index);
            return ListTile(
              leading: (c.avatar != null && c.avatar!.isNotEmpty)
                  ? CircleAvatar(backgroundImage: MemoryImage(c.avatar!))
                  : CircleAvatar(
                      backgroundColor: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      child: Text(
                        c.initials(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
              title: Text(c.displayName ?? ""),
              trailing: IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () => {
                        //Freund einladen
                      }),
              shape: const Border(
                top: BorderSide(color: Colors.blueGrey, width: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}
