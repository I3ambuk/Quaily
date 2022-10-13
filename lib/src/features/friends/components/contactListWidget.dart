import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quaily/src/features/friends/utils/contactListUtils.dart';
import 'package:quaily/src/features/friends/utils/customContact.dart';

class ContactListWidget extends StatefulWidget {
  @override
  ContactListWidgetState createState() => ContactListWidgetState();
}

class ContactListWidgetState extends State<ContactListWidget> {
  //TODO: Button Funktionalität zum Anfragen von Freunden
  //TODO: Neuer Abschnitt für momentane Freundesanfragen
  //TODO: Freundesanfrage annehmen Funktionalität
  //TODO: Button Funktionalität zum Einladen von Freunden
  //TODO: Kontakte schon beim starten der App initialisieren im Hintergrund

  TextEditingController searchbarController = TextEditingController();
  late IconButton addContactButton;
  late IconButton inviteContactButton;
  late Widget userContactListWidget;
  late Widget nonUserContactListWidget;
  bool showUserList = true;
  bool showNonUserList = true;

  @override
  void initState() {
    super.initState();
    addContactButton = IconButton(
        icon: const Icon(Icons.person_add),
        onPressed: () => {
              //Kontakt freundschaftsanfrage senden
            });
    inviteContactButton = IconButton(
        icon: const Icon(Icons.mail),
        onPressed: () => {
              //Kontakt zu Quaily einladen
            });
    render();
    initContacts(this);
    searchbarController.addListener(() {
      render();
    });
  }

  void render() {
    var userList = getUserContactListFiltered(filter: searchbarController.text);
    var nonUserList =
        getNonUserContactListFiltered(filter: searchbarController.text);

    setState(() {
      showUserList = userList.isNotEmpty;
      showNonUserList = nonUserList.isNotEmpty;

      userContactListWidget = getListWidget(userList, (c) => addContactButton);
      nonUserContactListWidget =
          getListWidget(nonUserList, (c) => inviteContactButton);
    });
  }

  @override
  Widget build(Object context) {
    return Column(
      children: <Widget>[
        Container(
          height: 100,
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
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Visibility(
                  visible: showUserList,
                  child: Container(
                    color: Colors.grey,
                    alignment: Alignment.center,
                    height: 30,
                    child: Text('Kontakte auf Quaily: '),
                  ),
                ),
              ),
              userContactListWidget,
              SliverToBoxAdapter(
                child: Visibility(
                  visible: showNonUserList,
                  child: Container(
                    color: Colors.grey,
                    alignment: Alignment.center,
                    height: 30,
                    child: Text('Kontakte einladen: '),
                  ),
                ),
              ),
              nonUserContactListWidget,
            ],
          ),
        ),
      ],
    );
  }
}

Widget getListWidget(List<Contact> list, Widget getButton(Contact c)) {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      childCount: list.length,
      (BuildContext context, int index) {
        Contact? c = list.elementAt(index);
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
                ? CircleAvatar(backgroundImage: MemoryImage(c.avatar!))
                : CircleAvatar(
                    backgroundColor: c.getColor(),
                    child: Text(
                      c.initials(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
            title: Text(c.displayName ?? ""),
            trailing: getButton(c),
          ),
        );
      },
    ),
  );
}
