import 'dart:math';

import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:quaily/src/features/friends/utils/contactListUtils.dart';

class ContactListWidget extends StatefulWidget {
  @override
  _ContactListWidgetState createState() => _ContactListWidgetState();
}

class _ContactListWidgetState extends State<ContactListWidget> {
  TextEditingController searchbarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshContacts();
    searchbarController
        .addListener(() => filterContacts(searchbarController.text));
  }

  @override
  Widget build(Object context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchbarController,
            decoration: InputDecoration(
              labelText: 'Search for Contact',
              border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(this.context).primaryColor),
              ),
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: SafeArea(
            child: ValueListenableBuilder<List<Contact>>(
              valueListenable: contactsNotifier,
              builder: (context, value, child) => ListView.builder(
                shrinkWrap: true,
                itemCount: contactsNotifier.value.length,
                itemBuilder: (BuildContext context, int index) {
                  Contact? c = contactsNotifier.value.elementAt(index);
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.blueGrey,
                          width: 1,
                        ),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(
                          left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
                      leading: (c.avatar != null && c.avatar!.isNotEmpty)
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(c.avatar!))
                          : CircleAvatar(
                              backgroundColor: Colors.primaries[
                                  Random().nextInt(Colors.primaries.length)],
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
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
