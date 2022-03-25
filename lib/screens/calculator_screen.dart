import 'package:calculator/config/themes/theme.dart';
import 'package:calculator/controller/history_controller.dart';
import 'package:calculator/screens/buttons_screen.dart';
import 'package:calculator/screens/result_screen.dart';
import 'package:calculator/utils/buttons.dart';
import 'package:calculator/utils/colors.dart';
import 'package:calculator/widgets/neumorphic_button.dart';
import 'package:calculator/widgets/scrollable_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/calculation.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final controller = Get.put(HistoryController());
  final scrollController = ScrollController();

  String errorText = '';

  @override
  Widget build(BuildContext context) {
    controller.isDarkMode.value = getThemeMode(context);
    return Scaffold(
      backgroundColor:
          controller.isDarkMode.value ? kBgColorDark : kBgColorLight,
      body: SnappingSheetTop(
        sheet: History(),
        body: Column(
          children: [
            Obx(() => ResultScreen(
                  result: controller.result.value,
                  scrollController: scrollController,
                )),
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
      ),
    );
  }

  onButtonClick(String button) {
    _scrollEnd();
    errorText = '';
    // setState(() {});

    switch (button) {
      case ACButton:
        controller.result.value = '';
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
        controller.result.value += button;
        break;
    }
    print(controller.result.value);
  }

  /// Buttons Functionality
  void posNegButton() {
    final resultArr = controller.result.value.split('');
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

    if (intValue >= 0) {
      for (var i = intValueArr.length - 1; i >= 0; i--) {
        resultArr.removeAt(resultArr.length - i);
      }
    } else {
      for (var i = intValueArr.length - 1; i >= 1; i--) {
        resultArr.removeAt(resultArr.length - i);
      }
    }
    controller.result.value = resultArr.join() + intValue.toString();
  }

  void perButton() {
    double doubleValue = double.parse(controller.result.value);
    doubleValue = doubleValue / 100;

    controller.result.value = doubleValue.toString();
  }

  void dotButton(String value) {
    if (controller.result.value.length > 0) {
      var lastChar =
          controller.result.value.split('')[controller.result.value.length - 1];
      if (lastChar != value) {
        controller.result.value += value;
      }
    } else {
      controller.result.value += value;
    }
  }

  void resultButtonNew() {
    controller.addValue(controller.result.value);
    final value = Calculation.evaluate(controller.result.value);
    controller.result.value = value.toString();
    controller.addValue(controller.result.value);
    print(controller.resultList.toString());
  }

  void getLastValueFromResult(String value) {
    if (controller.result.value.length > 0) {
      var lastChar =
          controller.result.value.split('')[controller.result.value.length - 1];
      if (lastChar == DivideButton ||
          lastChar == MulButton ||
          lastChar == AddButton ||
          lastChar == SubButton) {
        controller.result.value = controller.result.value
            .replaceFirst(lastChar, value, controller.result.value.length - 1);
      } else {
        controller.result.value += value;
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
        value == DivideButton ||
        value == '-') {
      return false;
    } else {
      return true;
    }
  }
}

class History extends StatelessWidget {
  History({Key? key}) : super(key: key);
  final HistoryController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: controller.isDarkMode.value
            ? Colors.grey.shade900
            : Colors.grey.shade100,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.all(16.0),
      child: Obx(
        () => controller.resultList.isEmpty
            ? Center(
                child: Text('No History Found',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: controller.isDarkMode.value
                            ? kTextColorLight
                            : kTextColorDark
                        // color: isDarkMode ? Colors.white70 : Colors.black87,
                        )),
              )
            : ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: controller.resultList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(controller.resultList[index],
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w300,
                            color: controller.isDarkMode.value
                                ? kTextColorLight
                                : kTextColorDark
                            // color: isDarkMode ? Colors.white70 : Colors.black87,
                            )),
                  );
                }),
      ),
    );
  }
}
