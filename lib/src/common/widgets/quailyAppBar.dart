import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuailyAppBar extends StatelessWidget {
  late Widget _leftIcon;
  late Widget _rightIcon;
  late String _title;

  QuailyAppBar(Widget leftIcon, String title, Widget rightIcon) {
    _leftIcon = SizedBox(height: 48.0, width: 48.0, child: leftIcon);
    _rightIcon = SizedBox(height: 48.0, width: 48.0, child: rightIcon);
    _title = title;
  }

  QuailyAppBar.onlyTitle(this._title) {
    _leftIcon = Container();
    _rightIcon = const SizedBox(
      height: 48.0,
      width: 48.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _leftIcon,
        Text(
          _title,
          style: GoogleFonts.specialElite(fontSize: 30.0),
        ),
        _rightIcon,
      ],
    );
  }
}
