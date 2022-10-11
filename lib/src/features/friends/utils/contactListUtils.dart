import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';

var contactsNotifier = ValueNotifier<List<Contact>>([]);

Future<void> refreshContacts() async {
  // Load without thumbnails initially.
  contactsNotifier.value =
      (await ContactsService.getContacts(withThumbnails: false));

  //Lazy load thumbnails after rendering initial contacts.
  for (final contact in contactsNotifier.value) {
    ContactsService.getAvatar(contact).then((avatar) {
      if (avatar == null) return; // Don't redraw if no change.
      contact.avatar = avatar;
    });
  }
}
