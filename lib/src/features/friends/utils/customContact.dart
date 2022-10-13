import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart' as cs;

class ContactsService extends cs.ContactsService {
  static Future<List<Contact>> getContactsNew({withThumbnails = true}) async {
    List<Contact> res = [];
    await cs.ContactsService.getContacts(withThumbnails: withThumbnails)
        .then((list) => list.forEach((contact) {
              Color rndColor =
                  Colors.primaries[Random().nextInt(Colors.primaries.length)];
              res.add(Contact(contact, color: rndColor));
            }));
    return res;
  }

  static Future<Uint8List?> getAvatar(final Contact contact,
          {final bool photoHighRes = true}) =>
      cs.ContactsService.getAvatar(contact, photoHighRes: photoHighRes);
}

class Contact extends cs.Contact {
  Color? color;

  Contact(cs.Contact? parent, {this.color}) {
    if (parent != null) {
      super.androidAccountName = parent.androidAccountName;
      super.androidAccountType = parent.androidAccountType;
      super.androidAccountTypeRaw = parent.androidAccountTypeRaw;
      super.avatar = parent.avatar;
      super.birthday = parent.birthday;
      super.company = parent.company;
      super.displayName = parent.displayName;
      super.emails = parent.emails;
      super.familyName = parent.familyName;
      super.givenName = parent.givenName;
      super.identifier = parent.identifier;
      super.jobTitle = parent.jobTitle;
      super.middleName = parent.middleName;
      super.phones = parent.phones;
      super.postalAddresses = parent.postalAddresses;
      super.prefix = parent.prefix;
      super.suffix = parent.suffix;
    }
  }

  void setColor(Color color) {
    this.color = color;
  }

  Color getColor() {
    return color ?? Colors.white;
  }
}

class Item extends cs.Item {
  Item(cs.Item? parent) {
    if (parent != null) {
      super.label = parent.label;
      super.value = parent.value;
    }
  }
}
