import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quaily/src/common/data/userInformation.dart' as userinfo;
import 'package:quaily/src/features/friends/utils/listUtils.dart' as friendlist;

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
            //andere Sachen bei Abmeldung zurücksetzten? Datenleak vermeiden!
            //BIG:Bessere Architektur überlegen um sicherzugehen, dass Daten beim Abmelden gelöscht
            //Welche daten werden wo langfristig gespeichert?
            //UtilKlassen zwingen clear zu implementieren? Evtl automatischer aufruf bei ausloggen mittels listener?
            friendlist.clear();
            userinfo.clear();
            await FirebaseAuth.instance.signOut().then((value) =>
                Navigator.pushNamedAndRemoveUntil(
                    context, '/signup', (route) => false));
          },
          child: const Text('LogOut'),
        ),
      ),
    );
  }
}
