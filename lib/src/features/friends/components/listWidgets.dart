import 'package:flutter/material.dart';
import 'package:quaily/src/common/utils/quailyUser.dart';
import 'package:quaily/src/features/friends/utils/customContact.dart';

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
