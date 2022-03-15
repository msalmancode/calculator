import 'package:calculator/config/themes/theme.dart';
import 'package:calculator/utils/colors.dart';
import 'package:calculator/utils/screen_size.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  ScrollController scrollController;
  String result, errorText;
  ResultScreen({
    Key? key,
    required this.result,
    this.errorText = '',
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = getThemeMode(context);
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
                      fontSize: getScreenHeight(context) * 0.10,
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
}
