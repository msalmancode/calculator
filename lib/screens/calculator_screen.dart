import 'package:calculator/config/themes/theme.dart';
import 'package:calculator/screens/buttons_screen.dart';
import 'package:calculator/screens/result_screen.dart';
import 'package:calculator/utils/buttons.dart';
import 'package:calculator/utils/colors.dart';
import 'package:calculator/widgets/neumorphic_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'calculation.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  ScrollController scrollController = ScrollController();
  bool isDarkMode = false;

  String result = '';
  String errorText = '';

  @override
  Widget build(BuildContext context) {
    isDarkMode = getThemeMode(context);
    return Scaffold(
      backgroundColor: isDarkMode ? kBgColorDark : kBgColorLight,
      body: Column(
        children: [
          ResultScreen(
            result: result,
            scrollController: scrollController,
          ),
          ButtonsScreen(
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
                      NeuMorphicButton(
                          action: () => onButtonClick('7'), text: '7'),
                      NeuMorphicButton(
                          action: () => onButtonClick('8'), text: '8'),
                      NeuMorphicButton(
                          action: () => onButtonClick('9'), text: '9'),
                      NeuMorphicButton(
                        action: () => onButtonClick('×'),
                        text: '×',
                        textColor: kPrimaryAccentColor,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      NeuMorphicButton(
                          action: () => onButtonClick('4'), text: '4'),
                      NeuMorphicButton(
                          action: () => onButtonClick('5'), text: '5'),
                      NeuMorphicButton(
                          action: () => onButtonClick('6'), text: '6'),
                      NeuMorphicButton(
                          action: () => onButtonClick('−'),
                          text: '−',
                          textColor: kPrimaryAccentColor)
                    ],
                  ),
                  TableRow(
                    children: [
                      NeuMorphicButton(
                          action: () => onButtonClick('1'), text: '1'),
                      NeuMorphicButton(
                          action: () => onButtonClick('2'), text: '2'),
                      NeuMorphicButton(
                          action: () => onButtonClick('3'), text: '3'),
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
                          action: () => onButtonClick(DotButton),
                          text: DotButton),
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
        ],
      ),
    );
  }

  onButtonClick(String button) {
    _scrollEnd();
    errorText = '';
    setState(() {});

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
        break;

      default:
        result += button;
        break;
    }
    print(result);
  }

  /// Buttons Functionality
  void posNegButton() {
    final resultArr = result.split('');
    String lastChar = '', lastNumber = '';
    for (var i = resultArr.length - 1; i >= 0; i--) {
      if (isNumber(resultArr[i])) {
        lastNumber += resultArr[i];
      } else {
        lastChar = resultArr[i];
        break;
      }
    }
    int intValue = int.parse(lastNumber.split('').reversed.join()) * -1;

    final intValueArr = intValue.toString().split('');
    for (var i = intValueArr.length - 1; i >= 1; i--) {
      resultArr.removeAt(resultArr.length - i);
    }
    result = resultArr.join() + intValue.toString();
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
    final value = Calculation.evaluate(result);
    result = value.toString();
  }

  void getLastValueFromResult(String value) {
    if (result.length > 0) {
      // debugger();
      var lastChar = result.split('')[result.length - 1];
      if (lastChar == DivideButton ||
          lastChar == MulButton ||
          lastChar == AddButton ||
          lastChar == SubButton) {
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

  String formatToThousand(String value) {
    final formatter = NumberFormat('#,##,###');
    try {
      return formatter.format(num.parse(value)).toString();
    } catch (e) {
      return value;
    }
  }

  static bool isNumber(String value) {
    if (value == AddButton ||
        value == SubButton ||
        value == MulButton ||
        value == DivideButton) {
      return false;
    } else {
      return true;
    }
  }
}
