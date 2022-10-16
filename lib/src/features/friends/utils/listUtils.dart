import 'package:flutter/material.dart';
import 'package:quaily/src/common/data/dataObject.dart';
import 'package:quaily/src/common/data/userInformation.dart';
import 'package:quaily/src/common/utils/quailyUser.dart';
import 'package:quaily/src/features/friends/utils/customContact.dart';
import 'package:quaily/src/features/friends/utils/firebaseSocket.dart';

class ListUtils extends CurrentUserData {
  ListUtils._privateConstructor();
  static final ListUtils instance = ListUtils._privateConstructor();

  //Maps all Contacts and QuailyUser with PhoneNumber as key
//Contacts which not use App
  var nonUserContactMap = ValueNotifier(<String, Contact>{});
//Contact which are Users,noFriends,noFriendRequestsIn, nofriendREquestsOut
  var userContactMap = ValueNotifier(<String, QuailyUser>{});
//Friends of User
  var friendMap = ValueNotifier(<String, QuailyUser>{});
//Incoming FriendRequests
  var friendRequestsIn = ValueNotifier(<String, QuailyUser>{});
//Outgoing Friendrequests
  var friendRequestsOut = ValueNotifier(<String, QuailyUser>{});

  ///Wird einmalig beim starten der App aufgerufen und initialisiert die benötigten Listen
  Future<bool> initContacts() async {
    if (nonUserContactMap.value.isEmpty &&
        CurrentUserInfo.instance.currentQuailyUser != null) {
      //Fetche alle Kontakte aus Kontakte und speichere sie in _nonUserContactMap -->initialer Zustad, da User unbekannt
      nonUserContactMap.value =
          (await ContactsService.getContactsNew(withThumbnails: false));
      //entferne falls eigene Nummer in den Kontakten
      nonUserContactMap.value
          .remove(CurrentUserInfo.instance.currentQuailyUser!.phone);

      //SMALL: map Friends to friendMap
      //friendMap.value = await fs.getFriends();

      friendRequestsIn.value =
          await FirebaseSocket.instance.getFriendrequestsIn();
      friendRequestsOut.value =
          await FirebaseSocket.instance.getFriendrequestsOut();
      //starte FirebaseListener, dieser Aktualisiert bei Änderung der UserCollection die Listen
      FirebaseSocket.instance.setUpUserListener();
      return true;
    }
    return false;
  }

  @override
  void clearData() {
    nonUserContactMap = ValueNotifier(<String, Contact>{});
    userContactMap = ValueNotifier(<String, QuailyUser>{});
    friendMap = ValueNotifier(<String, QuailyUser>{});
    friendRequestsIn = ValueNotifier(<String, QuailyUser>{});
    friendRequestsOut = ValueNotifier(<String, QuailyUser>{});
  }

  ///!critical! -Used on a lot of data when App starts-
  ///
  ///called from socket, when a new User is added to Firebase
  ///updates Lists acordingly
  void handleNewUser(QuailyUser quailyUser) {
    //only add number not already known
    if (userContactMap.value.containsKey(quailyUser.phone)) {
      return;
    }
    //escape if there is no matching phonenumbers found in list of nonUser Contacts
    //remove if found
    if (nonUserContactMap.value.remove(quailyUser.phone) == null) {
      return;
    }
    //add to userContactMap, if User not already in other List
    if (friendMap.value.containsKey(quailyUser.phone) ||
        friendRequestsIn.value.containsKey(quailyUser.phone) ||
        friendRequestsOut.value.containsKey(quailyUser.phone)) {
      return;
    }
    userContactMap.value.putIfAbsent(quailyUser.phone, () => quailyUser);
  }

  ///get List of Contacts from userContactList which pass filter
  List<QuailyUser> convertUserMapToList(
      Map<String, QuailyUser> map, String filter) {
    //filter userList with filter
    List<QuailyUser> toFilter = [];
    map.forEach((key, value) {
      toFilter.add(value);
    });
    if (filter != '') {
      String searchTerm = filter.toLowerCase();

      toFilter.retainWhere((quailyUser) {
        String displayName = quailyUser.displayname;
        String phone = quailyUser.phone;

        bool containsDisplayName =
            displayName.toLowerCase().contains(searchTerm);
        bool containsPhnNumber = phone.toLowerCase().contains(searchTerm);

        return containsDisplayName || containsPhnNumber;
      });
    }
    return toFilter; //_getFilteredList(_currentFilter, _userContacts);
  }

  ///get List of Contacts from nonUserContactList which pass filter
  List<Contact> convertContactMapToList(
      Map<String, Contact> map, String filter) {
    //filter nonuserList with filter
    List<Contact> toFilter = [];
    map.forEach((key, value) {
      toFilter.add(value);
    });
    if (filter != '') {
      String searchTerm = filter.toLowerCase();

      toFilter.retainWhere((contact) {
        String givename = contact.givenName ?? '';
        String displayname = contact.displayName ?? '';
        Item? number = Item(contact.phones?.firstWhere(
            (phn) =>
                phn.value != null ? phn.value!.contains(searchTerm) : false,
            orElse: () => Item(null)));

        bool containsGivenName = givename.toLowerCase().contains(searchTerm);
        bool containsDisplayName =
            displayname.toLowerCase().contains(searchTerm);
        bool containsPhnNumber = (number != Item(null));

        return containsGivenName || containsDisplayName || containsPhnNumber;
      });
    }
    return toFilter;
  }
}
