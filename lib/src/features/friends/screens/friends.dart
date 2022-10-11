import 'package:flutter/material.dart';
import 'package:quaily/src/common/widgets/quailyAppBar.dart';
import 'package:quaily/src/features/friends/components/contactListWidget.dart';

class Friends extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> with TickerProviderStateMixin {
  static const String _title = 'Friends';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
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
              child: ContactListWidget(),
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
