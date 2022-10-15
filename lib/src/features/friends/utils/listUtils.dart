import 'package:flutter/material.dart';
import 'package:quaily/src/common/utils/quailyUser.dart';
import 'package:quaily/src/features/friends/utils/customContact.dart';
import 'package:quaily/src/features/friends/utils/firebaseSocket.dart' as fs;

//Maps all Contacts and QuailyUser with PhoneNumber as key
//Contacts which not use App
var _nonUserContactMap = <String, Contact>{};
//Contact which are Users,noFriends,noFriendRequestsIn, nofriendREquestsOut
var _userContactMap = <String, QuailyUser>{};
//Friends of User
var _friendMap = <String, QuailyUser>{};
//Incoming FriendRequests
var _friendRequestsIn = <String, QuailyUser>{};
//Outgoing Friendrequests
var _friendRequestsOut = <String, QuailyUser>{};

String _currentFilter = '';

///Wird einmalig beim starten der App aufgerufen und initialisiert die benötigten Listen
Future<void> initContacts(ChangeNotifier notify) async {
  if (_nonUserContactMap.isEmpty) {
    //Fetche alle Kontakte aus Kontakte und speichere sie in _nonUserContactMap -->initialer Zustad, da User unbekannt
    _nonUserContactMap =
        (await ContactsService.getContactsNew(withThumbnails: false));
    //starte FirebaseListener, dieser Aktualisiert bei Änderung der UserCollection die Listen
    fs.setUpUserListener();

    //TODO: map Friends to friendMap
    //TODO: map incoming friendsRequests
    //TODO: map outgoing friendrequests
  }
}

///!critical! -Used on a lot of data when App starts-
///
///called from socket, when a new User is added to Firebase
///updates Lists acordingly
void handleNewUser(QuailyUser quailyUser) {
  //only add number not already known
  if (_userContactMap.containsKey(quailyUser.phone) ||
      _friendMap.containsKey(quailyUser.phone) ||
      _friendRequestsIn.containsKey(quailyUser.phone) ||
      _friendRequestsOut.containsKey(quailyUser.phone)) {
    return;
  }
  //escape if there is no matching phonenumbers found in list of nonUser Contacts
  //remove if found
  if (_nonUserContactMap.remove(quailyUser.phone) == null) {
    return;
  }
  _userContactMap.putIfAbsent(quailyUser.phone, () => quailyUser);
}

///get List of Contacts from userContactList which pass filter
List<QuailyUser> getUserContactList({String? filter}) {
  _currentFilter = filter ?? _currentFilter;
  //filter userList with filter
  List<QuailyUser> toFilter = [];
  _userContactMap.forEach((key, value) {
    toFilter.add(value);
  });
  if (filter != '') {
    String searchTerm = _currentFilter.toLowerCase();

    toFilter.retainWhere((quailyUser) {
      String displayName = quailyUser.displayname;
      String phone = quailyUser.phone;

      bool containsDisplayName = displayName.toLowerCase().contains(searchTerm);
      bool containsPhnNumber = phone.toLowerCase().contains(searchTerm);

      return containsDisplayName || containsPhnNumber;
    });
  }
  return toFilter; //_getFilteredList(_currentFilter, _userContacts);
}

///get List of Contacts from nonUserContactList which pass filter
List<Contact> getNonUserContactList({String? filter}) {
  _currentFilter = filter ?? _currentFilter;
  //filter nonuserList with filter
  List<Contact> toFilter = [];
  _nonUserContactMap.forEach((key, value) {
    toFilter.add(value);
  });
  if (filter != '') {
    String searchTerm = _currentFilter.toLowerCase();

    toFilter.retainWhere((contact) {
      String givename = contact.givenName ?? '';
      String displayname = contact.displayName ?? '';
      Item? number = Item(contact.phones?.firstWhere(
          (phn) => phn.value != null ? phn.value!.contains(searchTerm) : false,
          orElse: () => Item(null)));

      bool containsGivenName = givename.toLowerCase().contains(searchTerm);
      bool containsDisplayName = displayname.toLowerCase().contains(searchTerm);
      bool containsPhnNumber = (number != Item(null));

      return containsGivenName || containsDisplayName || containsPhnNumber;
    });
  }
  return toFilter;
}

List<Contact> getFriendRequests() {
  return [];
}
