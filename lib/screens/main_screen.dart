import 'package:calculator/config/themes/theme.dart';
import 'package:calculator/utils/buttons.dart';
import 'package:calculator/utils/colors.dart';
import 'package:calculator/utils/screen_size.dart';
import 'package:calculator/widgets/neumorphic_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'calculation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ScrollController scrollController = ScrollController();
  bool isDarkMode = false;

  String result = '';
  String errorText = '';

  @override
  Widget build(BuildContext context) {
    isDarkMode = getThemeMode(context);
    return Scaffold(
      backgroundColor: isDarkMode ? kBgColorDark : kBgColorLight,
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
      height: getScreenHeight(context) * 0.4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(flex: 1),
            Flexible(
              flex: 3,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: scrollController,
                reverse: true,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    result, //formatToThousand(result),
                    style: TextStyle(
                      fontSize: getScreenHeight(context) * 0.12,
                      fontWeight: FontWeight.w300,
                      color: errorText.length == 0
                          ? (isDarkMode ? kTextColorLight : kTextColorDark)
                          : Colors.red,
                      // color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  errorText,
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.red,
                    // color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Buttons Screen
  Widget buttonScreen() {
    return Container(
      width: double.infinity,
      height: getScreenHeight(context) * 0.6,
      child: Column(
        children: [
          Table(
            children: [
              TableRow(
                children: [
                  NeuMorphicButton(
                      action: () => onButtonClick(ACButton),
                      text: ACButton,
                      textColor: Colors.grey),
                  NeuMorphicButton(
                      action: () => onButtonClick(PosNegButton),
                      text: PosNegButton,
                      textColor: Colors.grey),
                  NeuMorphicButton(
                      action: () => onButtonClick(PerButton),
                      text: PerButton,
                      textColor: Colors.grey),
                  NeuMorphicButton(
                      action: () => onButtonClick(DivideButton),
                      text: DivideButton,
                      textColor: kPrimaryAccentColor),
                ],
              ),
              TableRow(
                children: [
                  NeuMorphicButton(action: () => onButtonClick('7'), text: '7'),
                  NeuMorphicButton(action: () => onButtonClick('8'), text: '8'),
                  NeuMorphicButton(action: () => onButtonClick('9'), text: '9'),
                  NeuMorphicButton(
                    action: () => onButtonClick('×'),
                    text: '×',
                    textColor: kPrimaryAccentColor,
                  ),
                ],
              ),
              TableRow(
                children: [
                  NeuMorphicButton(action: () => onButtonClick('4'), text: '4'),
                  NeuMorphicButton(action: () => onButtonClick('5'), text: '5'),
                  NeuMorphicButton(action: () => onButtonClick('6'), text: '6'),
                  NeuMorphicButton(
                      action: () => onButtonClick('−'),
                      text: '−',
                      textColor: kPrimaryAccentColor)
                ],
              ),
              TableRow(
                children: [
                  NeuMorphicButton(action: () => onButtonClick('1'), text: '1'),
                  NeuMorphicButton(action: () => onButtonClick('2'), text: '2'),
                  NeuMorphicButton(action: () => onButtonClick('3'), text: '3'),
                  NeuMorphicButton(
                    action: () => onButtonClick('+'),
                    text: '+',
                    textColor: kPrimaryAccentColor,
                  ),
                ],
              ),
            ],
          ),
          Table(
            columnWidths: <int, TableColumnWidth>{
              0: FractionColumnWidth(.50),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
            },
            children: [
              TableRow(
                children: [
                  NeuMorphicButton(
                      action: () => onButtonClick(Button0),
                      text: Button0,
                      isExpanded: true),
                  NeuMorphicButton(
                      action: () => onButtonClick(DotButton), text: DotButton),
                  NeuMorphicButton(
                    action: () => onButtonClick(ResultButton),
                    text: ResultButton,
                    textColor: kPrimaryAccentColor,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  onButtonClick(String button) {
    _scrollEnd();
    errorText = '';
    setState(() {});
    // final lastValue = getLastValueFromResult();

    switch (button) {
      case ACButton:
        result = '';
        break;
      case PosNegButton:
        posNegButton();
        break;
      case PerButton:
        perButton();
        break;

      case DivideButton:
        getLastValueFromResult(DivideButton);
        break;

      case MulButton:
        getLastValueFromResult(MulButton);
        break;

      case AddButton:
        getLastValueFromResult(AddButton);
        break;

      case SubButton:
        getLastValueFromResult(SubButton);
        break;

      case DotButton:
        dotButton(DotButton);
        break;

      case ResultButton:
        resultButtonNew();
        _scrollStart();
        break;

      default:
        result += button;
        break;
    }
    print(result);
  }

  /// Buttons Functionality
  void posNegButton() {
    final value = result.replaceAll('−', '-');
    int intValue = int.parse(value);
    intValue *= -1;

    result = intValue.toString();
  }

  void perButton() {
    double doubleValue = double.parse(result);
    doubleValue = doubleValue / 100;

    result = doubleValue.toString();
  }

  void dotButton(String value) {
    if (result.length > 0) {
      // debugger();
      var lastChar = result.split('')[result.length - 1];
      if (lastChar != value) {
        result += value;
      }
    } else {
      result += value;
    }
  }

  void resultButtonNew() {
    final value = EvaluateString.evaluate(result);
    result = value.toString();
  }

  void getLastValueFromResult(String value) {
    if (result.length > 0) {
      // debugger();
      var lastChar = result.split('')[result.length - 1];
      if (lastChar == DivideButton ||
          lastChar == MulButton ||
          lastChar == SubButton ||
          lastChar == AddButton) {
        result = result.replaceFirst(lastChar, value, result.length - 1);
      } else {
        result += value;
      }
    }
  }

  showError() {
    errorText = 'Invalid Format';
  }

  /// for text scroll to end
  void _scrollEnd() {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  /// for text scroll to start
  void _scrollStart() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  String formatToThousand(String value) {
    final formatter = NumberFormat('#,##,###');
    var convert = value;
    try {
      convert = formatter.format(num.parse(value)).toString();
    } catch (e) {}
    return convert;
  }
}
