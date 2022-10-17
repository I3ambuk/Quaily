import 'package:flutter/material.dart';
import 'package:quaily/src/common/utils/quailyUser.dart';
import 'package:quaily/src/common/widgets/quailyAppBar.dart';
import 'package:quaily/src/features/friends/utils/listUtils.dart';
import 'package:quaily/src/features/friends/components/listWidgets.dart'
    as widgets;

class FriendListWidget extends StatefulWidget {
  @override
  FriendListWidgetState createState() => FriendListWidgetState();
}

class FriendListWidgetState extends State<FriendListWidget> {
  var utils = ListUtils.instance;
  late Widget friendListWidget;

  @override
  void initState() {
    super.initState();
    renderFriendList();

    utils.friendMap.addListener(() {
      renderFriendList();
    });
  }

  void renderFriendList() {
    var friendList = utils.convertUserMapToList(utils.friendMap.value, '');
    setState(() {
      friendListWidget = widgets.getUserListWidget(
          friendList, (qu) => _createRemoveFriendButton(qu));
    });
  }

  Widget _createRemoveFriendButton(QuailyUser qu) {
    return IconButton(
        icon: const Icon(Icons.person_add),
        onPressed: () {
          //Kontakt freundschaftsanfrage senden
          utils.removeFriend(qu);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.grey,
                  alignment: Alignment.center,
                  height: 30,
                  child: const Text('Freunde: '),
                ),
              ),
              friendListWidget,
            ],
          ),
        ),
      ],
    );
  }
}
