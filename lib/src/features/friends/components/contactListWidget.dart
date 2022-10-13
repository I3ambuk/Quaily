import 'dart:math';

import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:quaily/src/features/friends/utils/contactListUtils.dart';

class ContactListWidget extends StatefulWidget {
  @override
  _ContactListWidgetState createState() => _ContactListWidgetState();
}

class _ContactListWidgetState extends State<ContactListWidget> {
  //TODO: contacts color doesnt change everytime (noRandom but Mapping)
  //TODO: Button Funktionalität zum Anfragen von Freunden
  //TODO: Neuer Abschnitt für momentane Freundesanfragen
  //TODO: Freundesanfrage annehmen Funktionalität
  //TODO: Button Funktionalität zum Einladen von Freunden

  TextEditingController searchbarController = TextEditingController();

  @override
  void initState() {
    super.initState();

    initContacts();
    renderContacts();

    searchbarController
        .addListener(() => filterContacts(searchbarController.text));
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
                child: Container(
                  color: Colors.grey,
                  alignment: Alignment.center,
                  height: 30,
                  child: Text('Kontakte auf Quaily: '),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: userContactsNotifier,
                builder: (context, value, child) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: userContactsNotifier.value.length,
                    (BuildContext context, int index) {
                      Contact? c = userContactsNotifier.value.elementAt(index);
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
                                  backgroundColor: Colors.primaries[Random()
                                      .nextInt(Colors.primaries.length)],
                                  child: Text(
                                    c.initials(),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                          title: Text(c.displayName ?? ""),
                          trailing: IconButton(
                              icon: const Icon(Icons.person_add),
                              onPressed: () => {
                                    //Freund hinzufügen
                                  }),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.grey,
                  alignment: Alignment.center,
                  height: 30,
                  child: Text('Kontakte einladen: '),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: nonUserContactsNotifier,
                builder: (context, value, child) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: nonUserContactsNotifier.value.length,
                    (BuildContext context, int index) {
                      Contact? c =
                          nonUserContactsNotifier.value.elementAt(index);
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
                                  backgroundColor: Colors.primaries[Random()
                                      .nextInt(Colors.primaries.length)],
                                  child: Text(
                                    c.initials(),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                          title: Text(c.displayName ?? ""),
                          trailing: IconButton(
                              icon: const Icon(Icons.mail),
                              onPressed: () => {
                                    //Freund einladen
                                  }),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


// Expanded(
        //   child: Column(
        //     children: [
              // Container(
              //   child: const Text('Kontakte auf BeReal: '),
              // ),
        //       Expanded(
        //         child: SafeArea(
        //           child: ValueListenableBuilder<List<Contact>>(
        //             valueListenable: userContactsNotifier,
        //             builder: (context, value, child) => ListView.builder(
        //               shrinkWrap: true,
        //               itemCount: userContactsNotifier.value.length,
        //               itemBuilder: (BuildContext context, int index) {
        //                 Contact? c = userContactsNotifier.value.elementAt(index);
        //                 return Container(
        //                   decoration: const BoxDecoration(
        //                     border: Border(
        //                       top: BorderSide(
        //                         color: Colors.blueGrey,
        //                         width: 1,
        //                       ),
        //                     ),
        //                   ),
        //                   child: ListTile(
        //                     contentPadding: const EdgeInsets.only(
        //                         left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
        //                     leading: (c.avatar != null && c.avatar!.isNotEmpty)
        //                         ? CircleAvatar(
        //                             backgroundImage: MemoryImage(c.avatar!))
        //                         : CircleAvatar(
        //                             backgroundColor: Colors.primaries[Random()
        //                                 .nextInt(Colors.primaries.length)],
        //                             child: Text(
        //                               c.initials(),
        //                               style:
        //                                   const TextStyle(color: Colors.black),
        //                             ),
        //                           ),
        //                     title: Text(c.displayName ?? ""),
        //                     trailing: IconButton(
        //                         icon: const Icon(Icons.person_add),
        //                         onPressed: () => {
        //                               //Freund hinzufügen
        //                             }),
        //                   ),
        //                 );
        //               },
        //             ),
        //           ),
        //         ),
        //       ),
        //       Container(
        //         child: const Text('Lade Kontakte ein: '),
        //       ),
        //       Expanded(
        //         child: SafeArea(
        //           child: ValueListenableBuilder<List<Contact>>(
        //             valueListenable: contactsNotifier,
        //             builder: (context, value, child) => ListView.builder(
        //               shrinkWrap: true,
        //               itemCount: contactsNotifier.value.length,
        //               itemBuilder: (BuildContext context, int index) {
        //                 Contact? c = contactsNotifier.value.elementAt(index);
        //                 return Container(
        //                   decoration: const BoxDecoration(
        //                     border: Border(
        //                       top: BorderSide(
        //                         color: Colors.blueGrey,
        //                         width: 1,
        //                       ),
        //                     ),
        //                   ),
        //                   child: ListTile(
        //                     contentPadding: const EdgeInsets.only(
        //                         left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
        //                     leading: (c.avatar != null && c.avatar!.isNotEmpty)
        //                         ? CircleAvatar(
        //                             backgroundImage: MemoryImage(c.avatar!))
        //                         : CircleAvatar(
        //                             backgroundColor: Colors.primaries[Random()
        //                                 .nextInt(Colors.primaries.length)],
        //                             child: Text(
        //                               c.initials(),
        //                               style:
        //                                   const TextStyle(color: Colors.black),
        //                             ),
        //                           ),
        //                     title: Text(c.displayName ?? ""),
        //                     trailing: IconButton(
        //                         icon: const Icon(Icons.mail),
        //                         onPressed: () => {
        //                               //Freund einladen
        //                             }),
        //                   ),
        //                 );
        //               },
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),