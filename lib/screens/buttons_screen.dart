import 'package:calculator/utils/screen_size.dart';
import 'package:flutter/material.dart';

class ButtonsScreen extends StatelessWidget {
  List<Widget> children;
  ButtonsScreen({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: getScreenHeight(context) * 0.6,
      child: Column(
        children: children,
      ),
    );
  }
}
