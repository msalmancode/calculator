import 'package:calculator/utils/screen_size.dart';
import 'package:calculator/widgets/neumorphic_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final formatter = NumberFormat('#,##,###');

  String result = '0';
  bool isDarkMode = false;

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF181818) : Colors.grey.shade300,
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: [
        resultScreen(),
        buttonScreen(),
      ],
    );
  }

  /// Result Screen
  Widget resultScreen() {
    return Container(
      width: double.infinity,
      height: getScreenSize(context) * 0.4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          reverse: true,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              formatToThousand(result),
              style: TextStyle(
                  fontSize: 100.0,
                  fontWeight: FontWeight.w300,
                  color: isDarkMode ? Colors.white70 : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  /// Buttons Screen
  Widget buttonScreen() {
    return Container(
      width: double.infinity,
      height: getScreenSize(context) * 0.6,
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NeumorphicButton(
                action: () => onButtonClick('AC'),
                text: 'AC',
                diameter: 20.0,
                textColor: Colors.grey,
              ),
              SizedBox(width: 20.0),
              NeumorphicButton(
                action: () => onButtonClick('+/-'),
                text: '+/-',
                diameter: 20.0,
                textColor: Colors.grey,
              ),
              SizedBox(width: 20.0),
              NeumorphicButton(
                action: () => onButtonClick('%'),
                text: '%',
                diameter: 20.0,
                textColor: Colors.grey,
              ),
              SizedBox(width: 20.0),
              NeumorphicButton(
                action: () => onButtonClick('÷'),
                text: '÷',
                diameter: 20.0,
                textColor: Colors.orange.shade500,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NeumorphicButton(
                action: () => onButtonClick('7'),
                text: '7',
                diameter: 20.0,
              ),
              SizedBox(width: 20.0),
              NeumorphicButton(
                action: () => onButtonClick('8'),
                text: '8',
                diameter: 20.0,
              ),
              SizedBox(width: 20.0),
              NeumorphicButton(
                action: () => onButtonClick('9'),
                text: '9',
                diameter: 20.0,
              ),
              SizedBox(width: 20.0),
              NeumorphicButton(
                action: () => onButtonClick('×'),
                text: '×',
                diameter: 20.0,
                textColor: Colors.orange.shade500,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NeumorphicButton(
                action: () => onButtonClick('4'),
                text: '4',
                diameter: 20.0,
              ),
              SizedBox(width: 20.0),
              NeumorphicButton(
                action: () => onButtonClick('5'),
                text: '5',
                diameter: 20.0,
              ),
              SizedBox(width: 20.0),
              NeumorphicButton(
                action: () => onButtonClick('6'),
                text: '6',
                diameter: 20.0,
              ),
              SizedBox(width: 20.0),
              NeumorphicButton(
                action: () => onButtonClick('−'),
                text: '−',
                diameter: 20.0,
                textColor: Colors.orange.shade500,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NeumorphicButton(
                action: () => onButtonClick('1'),
                text: '1',
                diameter: 20.0,
              ),
              SizedBox(width: 20.0),
              NeumorphicButton(
                action: () => onButtonClick('2'),
                text: '2',
                diameter: 20.0,
              ),
              SizedBox(width: 20.0),
              NeumorphicButton(
                action: () => onButtonClick('3'),
                text: '3',
                diameter: 20.0,
              ),
              SizedBox(width: 20.0),
              NeumorphicButton(
                action: () => onButtonClick('+'),
                text: '+',
                diameter: 20.0,
                textColor: Colors.orange.shade500,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NeumorphicButton(
                action: () => onButtonClick('0'),
                text: '0',
                diameter: 20.0,
              ),
              SizedBox(width: 120.0),
              NeumorphicButton(
                action: () => onButtonClick('.'),
                text: '.',
                diameter: 20.0,
              ),
              SizedBox(width: 20.0),
              NeumorphicButton(
                action: () => onButtonClick('='),
                text: '=',
                diameter: 20.0,
                textColor: Colors.orange.shade500,
              ),
            ],
          )
        ],
      ),
    );
  }

  onButtonClick(String button) {
    _scrollEnd();
    print('result $result');
    if (button == 'AC') {
      result = '0';
    } else {
      result = result + button;
    }
    setState(() {});
  }

  /// for text scroll to end
  void _scrollEnd() {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  String formatToThousand(String value) {
    var convert = value;
    try {
      convert = formatter.format(double.parse(value)).toString();
    } catch (e) {}
    return convert;
  }
}
