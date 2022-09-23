import 'package:flutter/material.dart';

class SignUpAppBar extends StatelessWidget {
  static const String _title = 'Quaily';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [const Text(_title)],
    );
  }
}
