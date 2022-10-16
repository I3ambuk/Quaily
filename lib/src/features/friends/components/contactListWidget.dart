import 'package:flutter/material.dart';
import 'package:quaily/src/common/utils/quailyUser.dart';
import 'package:quaily/src/features/friends/utils/customContact.dart';
import 'package:quaily/src/features/friends/utils/firebaseSocket.dart';
import 'package:quaily/src/features/friends/utils/listUtils.dart';

class ContactListWidget extends StatefulWidget {
  @override
  ContactListWidgetState createState() => ContactListWidgetState();
}

//TODO: Freunde anzeigen im FreundeTab
//BIG: User can search for existing quaily Contacts by name and phone
class ContactListWidgetState extends State<ContactListWidget> {
  //TODO: Freundesanfrage annehmen/ablehnen Funktionalität
  FirebaseSocket socket = FirebaseSocket.instance;
  ListUtils utils = ListUtils.instance;

  TextEditingController searchbarController = TextEditingController();
  late Widget userListWidget;
  late Widget contactListWidget;
  late Widget friendRequestInWidget;
  late Widget friendRequestOutWidget;
  bool showUserList = true;
  bool showContactList = true;
  bool showFriendRequestOut = true;
  bool showFriendRequestIn = true;

  Widget createAddContact(QuailyUser qu) {
    return IconButton(
        icon: const Icon(Icons.person_add),
        onPressed: () {
          //Kontakt freundschaftsanfrage senden
          socket.sendFriendRequest(qu);
        });
  }

  Widget createInviteContact(Contact c) {
    return IconButton(
        icon: const Icon(Icons.mail),
        onPressed: () {
          //Kontakt zu Quaily einladen
          socket.inviteContact(c);
        });
  }

  Widget createAcceptDeclineFriend(QuailyUser qu) {
    return SizedBox(
      width: 100,
      child: Row(
        children: [
          IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                //Kontakt zu Quaily einladen
                socket.addFriend(qu);
              }),
          IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                //Kontakt zu Quaily einladen
                socket.declineFriendRequest(qu);
              }),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    renderUserContact();
    renderContacts();
    renderFriendRequestIn();
    renderFriendRequestOut();

    searchbarController.addListener(() {
      renderContacts();
      renderUserContact();
    });

    utils.userContactMap.addListener(() {
      renderUserContact();
    });
    utils.nonUserContactMap.addListener(() {
      renderContacts();
    });

    utils.friendMap.addListener(() {});
    utils.friendRequestsIn.addListener(() {
      renderFriendRequestIn();
    });
    utils.friendRequestsOut.addListener(() {
      renderFriendRequestOut();
    });
  }

  void renderUserContact() {
    var userList = utils.convertUserMapToList(
        utils.userContactMap.value, searchbarController.text);
    setState(() {
      showUserList = userList.isNotEmpty;
      userListWidget = getUserListWidget(userList, (c) => createAddContact(c));
    });
  }

  void renderContacts() {
    var contactList = utils.convertContactMapToList(
        utils.nonUserContactMap.value, searchbarController.text);
    setState(() {
      showContactList = contactList.isNotEmpty;
      contactListWidget =
          getContactListWidget(contactList, (c) => createInviteContact(c));
    });
  }

  void renderFriendRequestIn() {
    var friendRequestsIn = utils.convertUserMapToList(
        utils.friendRequestsIn.value, searchbarController.text);
    setState(() {
      showFriendRequestIn = friendRequestsIn.isNotEmpty;
      friendRequestInWidget = getUserListWidget(
          friendRequestsIn, (c) => createAcceptDeclineFriend(c));
    });
  }

  void renderFriendRequestOut() {
    var friendRequestsOut = utils.convertUserMapToList(
        utils.friendRequestsOut.value, searchbarController.text);
    setState(() {
      showFriendRequestOut = friendRequestsOut.isNotEmpty;
      friendRequestOutWidget = getUserListWidget(
          friendRequestsOut,
          (c) => Container(
                width: 5,
              ));
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
                  visible: showFriendRequestOut,
                  child: Container(
                    color: Colors.grey,
                    alignment: Alignment.center,
                    height: 30,
                    child: Text('Anfrage gesendet: '),
                  ),
                ),
              ),
              friendRequestOutWidget,
              SliverToBoxAdapter(
                child: Visibility(
                  visible: showFriendRequestIn,
                  child: Container(
                    color: Colors.grey,
                    alignment: Alignment.center,
                    height: 30,
                    child: Text('Freundesanfragen: '),
                  ),
                ),
              ),
              friendRequestInWidget,
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
              userListWidget,
              SliverToBoxAdapter(
                child: Visibility(
                  visible: showContactList,
                  child: Container(
                    color: Colors.grey,
                    alignment: Alignment.center,
                    height: 30,
                    child: Text('Kontakte einladen: '),
                  ),
                ),
              ),
              contactListWidget,
            ],
          ),
        ),
      ],
    );
  }
}

Widget getContactListWidget(
    List<Contact> list, Widget Function(Contact c) iconButton) {
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
            trailing: iconButton(c),
          ),
        );
      },
    ),
  );
}

Widget getUserListWidget(
    List<QuailyUser> list, Widget Function(QuailyUser qu) iconButton) {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      childCount: list.length,
      (BuildContext context, int index) {
        QuailyUser? qu = list.elementAt(index);
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
            leading: CircleAvatar(backgroundImage: qu.avatar),
            title: Text(qu.displayname),
            trailing: iconButton(qu),
          ),
        );
      },
    ),
  );
}
