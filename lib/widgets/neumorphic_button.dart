import 'package:calculator/config/themes/theme.dart';
import 'package:calculator/utils/colors.dart';
import 'package:calculator/utils/screen_size.dart';
import 'package:flutter/material.dart';

class NeuMorphicButton extends StatefulWidget {
  final Function action;
  final String text;
  final Color? textColor;
  final bool isExpanded;

  const NeuMorphicButton({
    Key? key,
    required this.action,
    required this.text,
    this.textColor,
    this.isExpanded = false,
  }) : super(key: key);
  @override
  _NeuMorphicButtonState createState() => _NeuMorphicButtonState();
}

class _NeuMorphicButtonState extends State<NeuMorphicButton> {
  bool _isPressed = false;
  bool isDarkMode = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = !_isPressed;
      widget.action();
    });
  }

  void _onPointerUp(PointerUpEvent event) async {
    await Future.delayed(Duration(milliseconds: 100));
    setState(() => _isPressed = !_isPressed);
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = getThemeMode(context);
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: SizedBox(
        height: (MediaQuery.of(context).size.height * 0.6) * 0.19,
        width: MediaQuery.of(context).size.width * 0.25,
        // width: MediaQuery.of(context).size.width * widget.diameter /100,
        child: AnimatedContainer(
          margin:
              EdgeInsets.all(MediaQuery.of(context).size.shortestSide * 0.02),
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.all(16.0),
          decoration: neuMorphicDecoration(),
          child: widget.isExpanded
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: textWidget(),
                  ),
                )
              : FittedBox(
                  fit: BoxFit.contain,
                  child: textWidget(),
                ),
        ),
      ),
    );
  }

  Widget textWidget() {
    return Text(
      widget.text,
      style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: getScreenHeight(context) * 0.04,
          color: widget.textColor ??
              (isDarkMode ? kTextColorLight : kTextColorDark)),
    );
  }

  Decoration neuMorphicDecoration() {
    if (widget.isExpanded) {
      return BoxDecoration(
        color: isDarkMode ? kBgColorDark : kBgColorLight,
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: neuMorphicShadow(),
      );
    } else {
      return BoxDecoration(
        color: isDarkMode ? kBgColorDark : kBgColorLight,
        shape: BoxShape.circle,
        boxShadow: neuMorphicShadow(),
      );
    }
  }

  List<BoxShadow> neuMorphicShadow() {
    double bevel = 2.0;
    if (_isPressed) {
      return [
        BoxShadow(
          color: isDarkMode ? Colors.black : Colors.grey.shade500,
          offset: Offset(-bevel, -bevel),
          blurRadius: 5,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: isDarkMode ? Colors.grey.shade900 : Colors.white,
          offset: Offset(bevel, bevel),
          blurRadius: 5,
          spreadRadius: 1,
        )
      ];
    } else {
      return [
        BoxShadow(
          color: isDarkMode ? Colors.black : Colors.grey.shade500,
          offset: Offset(bevel, bevel),
          blurRadius: 5,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: isDarkMode ? Colors.grey.shade900 : Colors.white,
          offset: Offset(-bevel, -bevel),
          blurRadius: 5,
          spreadRadius: 1,
        )
      ];
    }
  }
}
