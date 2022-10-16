import 'package:flutter/material.dart';
import 'package:quaily/src/common/utils/signOutHandler.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static const String _title = 'Settings';

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
      body: Center(
        child: TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.red),
          ),
          onPressed: () async {
            SignOutHandler.instance.signOut().then((value) =>
                Navigator.pushNamedAndRemoveUntil(
                    context, '/signup', (route) => false));
          },
          child: const Text('LogOut'),
        ),
      ),
    );
  }
}
