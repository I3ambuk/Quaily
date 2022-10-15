import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart' as cs;

class ContactsService extends cs.ContactsService {
  static Future<Map<String, Contact>> getContactsNew(
      {withThumbnails = true}) async {
    var res = <String, Contact>{};
    await cs.ContactsService.getContacts(withThumbnails: withThumbnails)
        .then((list) {
      for (cs.Contact contact in list) {
        Color rndColor =
            Colors.primaries[Random().nextInt(Colors.primaries.length)];
        if (contact.phones != null &&
            contact.phones!.isNotEmpty &&
            contact.phones!.first.value != null) {
          res.putIfAbsent(contact.phones!.first.value!,
              () => Contact(contact, color: rndColor));
        }
      }
    });
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
