import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quaily/src/common/utils/permissionHandler.dart';
import 'package:quaily/src/features/friends/components/contactListWidget.dart';

class Friends extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> with TickerProviderStateMixin {
  //SMALL: momentane Freunde anzeigen
  //TODO: momentane Freunde entfernen Funktionalität

  static const String _title = 'Friends';
  late TabController _tabController;
  bool permission = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _askPermissions();
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      setState(() => permission = true);
    } else {
      _handleInvalidPermissions(permissionStatus);
      setState(() => permission = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    //_askPermissions();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            const Text(_title),
            const SizedBox(width: 32.0, height: 32.0),
          ],
        ),
      ),
      body: Scaffold(
        appBar: TabBar(
          controller: _tabController,
          labelColor: Colors.blueGrey,
          tabs: const <Widget>[
            Tab(
              icon: Text('Add Friends'),
            ),
            Tab(
              icon: Text('Friends'),
            ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Center(
              child: permission
                  ? ContactListWidget()
                  : const Text("Fehlende Berechtigung um Kontakte anzuzeigen"),
            ),
            Center(
              child: Text("Bereits registrierte Freunde anzeigen"),
            ),
          ],
        ),
      ),
    );
  }
}
