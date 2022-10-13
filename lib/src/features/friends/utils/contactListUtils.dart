import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<Contact> _nonUserContacts = [];
List<Contact> _userContacts = [];
List<String> _nonUserPhonenumbers = [];
List<String> _userPhonenumbers = [];
var userContactsNotifier = ValueNotifier<List<Contact>>([]);
var nonUserContactsNotifier = ValueNotifier<List<Contact>>([]);
var snapshotStream = FirebaseFirestore.instance.collection('users').snapshots();

//private
void _extractPhoneFromContacts(List<String> out, List<Contact> contactList) {
  for (var contact in contactList) {
    if (contact.phones != null &&
        contact.phones!.isNotEmpty &&
        contact.phones!.first.value != null) {
      out.add(contact.phones!.first.value!);
    }
  }
}

//listen to new users, if they match with a contact number, update lists accordingly
void _setUpUserListener() {
  snapshotStream.listen((querySnapshot) {
    for (var diff in querySnapshot.docChanges) {
      if (diff.type == DocumentChangeType.added && diff.doc.exists) {
        String userPhonenumber =
            diff.doc.data().toString().contains('phoneNumber')
                ? diff.doc.get('phoneNumber')
                : 'NoPhone';
        //only add number to userPhonenumbers once
        if (_userPhonenumbers.contains(userPhonenumber)) {
          return;
        }
        //escape if there is no matching phonenumbers found
        if (!_nonUserPhonenumbers.contains(userPhonenumber)) {
          return;
        }
        //update phonenumberlists
        _userPhonenumbers.add(userPhonenumber);
        _nonUserPhonenumbers.remove(userPhonenumber);

        //update contactLists
        _updateContacts(userPhonenumber);
      }
      if (diff.type == DocumentChangeType.removed) {
        //remove from phoneWithApp and update userContactsNotifier
      }
    }
  }, onError: (error) => print('Error fetching snapshots: $error'));
}

void _updateContacts(String phone) {
  var contactToRemove = Contact();
  for (var contact in _nonUserContacts) {
    if (contact.phones != null) {
      if (contact.phones!.any((element) => element.value == phone)) {
        _userContacts.add(contact);
        contactToRemove = contact;
      }
    }
  }
  _nonUserContacts.remove(contactToRemove);
}

List<Contact> _getFilteredList(String filter, List<Contact> listToFilter) {
  List<Contact> filtered = List<Contact>.from(listToFilter);
  if (filter != '') {
    String searchTerm = filter.toLowerCase();

    filtered.retainWhere((contact) {
      String givename = contact.givenName ?? '';
      String displayname = contact.displayName ?? '';
      Item? number = contact.phones?.firstWhere(
          (phn) => phn.value != null ? phn.value!.contains(searchTerm) : false,
          orElse: () => Item());

      bool containsGivenName = givename.toLowerCase().contains(searchTerm);
      bool containsDisplayName = displayname.toLowerCase().contains(searchTerm);
      bool containsPhnNumber = (number != null && number != Item());

      return containsGivenName || containsDisplayName || containsPhnNumber;
    });
  }
  return filtered;
}

//public
Future<void> initContacts() async {
  if (_nonUserContacts.isEmpty) {
    _nonUserContacts = (await ContactsService.getContacts());
  }

  _extractPhoneFromContacts(_nonUserPhonenumbers, _nonUserContacts);

  //listen to new users, if there phonenumber matches with a contact number, all needed lists are updated
  //No Users are known at the beginning
  _setUpUserListener();
}

void renderContacts({List<Contact>? ucList, List<Contact>? nucList}) {
  userContactsNotifier.value.clear();
  userContactsNotifier.value.addAll(ucList ?? _userContacts);

  nonUserContactsNotifier.value.clear();
  nonUserContactsNotifier.value.addAll(nucList ?? _nonUserContacts);
}

void filterContacts(String filter) {
  List<Contact> filteredUserContacts = _getFilteredList(filter, _userContacts);

  List<Contact> filteredNonUserContacts =
      _getFilteredList(filter, _nonUserContacts);
  renderContacts(
      ucList: filteredUserContacts, nucList: filteredNonUserContacts);
}
