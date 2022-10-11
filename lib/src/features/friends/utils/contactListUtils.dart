import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';

List<Contact> allContacts = [];
var contactsNotifier = ValueNotifier<List<Contact>>([]);

Future<void> refreshContacts() async {
  // Load without thumbnails initially.
  allContacts = (await ContactsService.getContacts(withThumbnails: false));

  contactsNotifier.value.addAll(allContacts);
  //Lazy load thumbnails after rendering initial contacts.
  for (final contact in allContacts) {
    ContactsService.getAvatar(contact).then((avatar) {
      if (avatar == null) return; // Don't redraw if no change.
      contact.avatar = avatar;
    });
  }
  contactsNotifier.value.clear();
  contactsNotifier.value.addAll(allContacts);
}

void filterContacts(String filter) {
  List<Contact> filteredContacts = [];
  filteredContacts.addAll(allContacts);
  if (filter != '') {
    String searchTerm = filter.toLowerCase();
    filteredContacts.retainWhere((contact) {
      String displayName = contact.givenName ?? "";
      return displayName.toLowerCase().contains(searchTerm);
    });
  }
  contactsNotifier.value.clear();
  contactsNotifier.value.addAll(filteredContacts);
}
