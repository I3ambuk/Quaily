import 'package:flutter/material.dart';
import 'package:quaily/src/common/data/userInformation.dart' as userInfo;
import 'package:quaily/src/common/utils/quailyUser.dart';

import 'package:quaily/src/common/widgets/quailyAppBar.dart';
import 'package:quaily/src/common/services/firebase/firebaseFunctions.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const _title = 'Quaily.';
  var pb = userInfo.currentQuailyUser!.avatar;

  @override
  void initState() {
    super.initState();
    userInfo.currentQuailyUser!.addListener(() {
      setState(() {
        pb = userInfo.currentQuailyUser!.avatar;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: QuailyAppBar(
          IconButton(
            iconSize: 32.0,
            onPressed: () => Navigator.pushNamed(context, '/friends'),
            icon: const Icon(
              Icons.person_add,
            ),
          ),
          _title,
          Container(
            padding: const EdgeInsets.all(4.0),
            child: Material(
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: Ink.image(
                image: pb,
                fit: BoxFit.cover,
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
