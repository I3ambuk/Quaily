import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quaily/src/features/friends/components/contactListWidget.dart';
import 'package:quaily/src/features/friends/utils/customContact.dart';

List<Contact> _nonUserContacts = [];
List<Contact> _userContacts = [];
List<String> _nonUserPhonenumbers = [];
List<String> _userPhonenumbers = [];
String _currentFilter = '';
var snapshotStream = FirebaseFirestore.instance.collection('users').snapshots();

//public methods
Future<void> initContacts(ContactListWidgetState state) async {
  if (_nonUserContacts.isEmpty) {
    _nonUserContacts =
        (await ContactsService.getContactsNew(withThumbnails: false));
    _extractPhoneFromContacts(_nonUserPhonenumbers, _nonUserContacts);
    //listen to new users, if there phonenumber matches with a contact number, all needed lists are updated
    //No Users are known at the beginning
    _setUpUserListener(state);
    //Lazy load thumbnails after rendering initial contacts
    for (final contact in _nonUserContacts) {
      ContactsService.getAvatar(contact).then((avatar) {
        if (avatar == null) return; // Don't redraw if no change.
        contact.avatar = avatar;
        state.render();
      });
    }
  }
}

List<Contact> getUserContactListFiltered({String? filter}) {
  _currentFilter = filter ?? _currentFilter;
  //filter userList with filter
  return _getFilteredList(_currentFilter, _userContacts);
}

List<Contact> getNonUserContactListFiltered({String? filter}) {
  _currentFilter = filter ?? _currentFilter;
  //filter nonuserList with filter
  return _getFilteredList(_currentFilter, _nonUserContacts);
}

void addContactAsFriend(Contact c) {
  print(c.givenName);
  //TODO: Freundesanfrage funktionalität
}

void inviteContact(Contact c) {
  //TODO: Freund einladen funktionalität
  print(c.givenName);
}

//private
List<Contact> _getFilteredList(String filter, List<Contact> listToFilter) {
  List<Contact> filtered = List<Contact>.from(listToFilter);
  if (filter != '') {
    String searchTerm = filter.toLowerCase();

    filtered.retainWhere((contact) {
      String givename = contact.givenName ?? '';
      String displayname = contact.displayName ?? '';
      Item? number = Item(contact.phones?.firstWhere(
          (phn) => phn.value != null ? phn.value!.contains(searchTerm) : false,
          orElse: () => Item(null)));

      bool containsGivenName = givename.toLowerCase().contains(searchTerm);
      bool containsDisplayName = displayname.toLowerCase().contains(searchTerm);
      bool containsPhnNumber = (number != null && number != Item(null));

      return containsGivenName || containsDisplayName || containsPhnNumber;
    });
  }
  return filtered;
}

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
void _setUpUserListener(ContactListWidgetState state) {
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

        //renderContactsInParentState
        state.render();
      }
      if (diff.type == DocumentChangeType.removed) {
        //remove from phoneWithApp and update userContactsNotifier
      }
    }
  }, onError: (error) => print('Error fetching snapshots: $error'));
}

void _updateContacts(String phone) {
  var contactToRemove = Contact(null);
  for (var contact in _nonUserContacts) {
    if (contact.phones != null) {
      if (contact.phones!.any((element) => element.value == phone)) {
        _userContacts.add(contact);
        contactToRemove = contact;
        break;
      }
    }
  }
  _nonUserContacts.remove(contactToRemove);
}
