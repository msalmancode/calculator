import 'package:flutter/material.dart';

class NeumorphicButton extends StatefulWidget {
  final Function action;
  final double diameter;
  final String text;
  final Color? textColor;

  const NeumorphicButton({
    Key? key,
    required this.action,
    required this.diameter,
    required this.text,
    this.textColor,
  }) : super(key: key);
  @override
  _NeumorphicButtonState createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
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
    final brightness = MediaQuery.of(context).platformBrightness;
    isDarkMode = brightness == Brightness.dark;
    return Listener(
        onPointerDown: _onPointerDown,
        onPointerUp: _onPointerUp,
        child: AnimatedContainer(
          height: MediaQuery.of(context).size.width * widget.diameter / 100,
          width: MediaQuery.of(context).size.width * widget.diameter / 100,
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.all(20.0),
          decoration: neumorphicDecoration(),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w400,
                  color: widget.textColor ??
                      (isDarkMode ? Colors.white70 : Colors.black87)),
            ),
          ),
        ));
  }

  Decoration neumorphicDecoration() {
    double bevel = 2.0;
    return BoxDecoration(
      color: isDarkMode ? const Color(0xFF181818) : Colors.grey.shade300,
      shape: BoxShape.circle,
      boxShadow: !_isPressed
          ? [
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
            ]
          : [
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
            ],
    );
  }
}
