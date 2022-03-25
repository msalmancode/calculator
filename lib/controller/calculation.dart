import 'package:calculator/utils/buttons.dart';
import 'package:calculator/utils/stack.dart';

class Calculation {
  static num evaluate(String expression) {
    expression = expression.replaceAll('-', SubButton);

    // To Solve Negation
    final tokens = expression.split('');
    for (int x = 1; x < tokens.length; x++) {
      if (!isNumber(tokens[x])) {
        final current = tokens[x];
        final last = tokens[x - 1];

        if ((current == SubButton || current == AddButton) &&
            ((last == SubButton || last == AddButton))) {
          if (current == last) {
            tokens[x] = AddButton;
            tokens.removeAt(x - 1);
          } else {
            tokens[x] = SubButton;
            tokens.removeAt(x - 1);
          }
        }
      }
    }

    // Stack for numbers: 'values'
    Stack<num> values = new Stack<num>();

    // Stack for Operators: 'ops'
    Stack<String> ops = new Stack<String>();

    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i] == ' ') continue;

      if (isNumber(tokens[i])) {
        StringBuffer sbuf = StringBuffer();

        while (i < tokens.length && isNumber(tokens[i])) {
          sbuf.write(tokens[i++]);
        }
        values.push(num.parse(sbuf.toString()));

        i--;
      } else if (tokens[i] == AddButton ||
          tokens[i] == SubButton ||
          tokens[i] == MulButton ||
          tokens[i] == DivideButton) {
        while (ops.isNotEmpty && hasPrecedence(tokens[i], ops.top)) {
          values.push(applyOp(ops.pop(), values.pop(), values.pop()));
        }

        // Push current token to 'ops'.
        ops.push(tokens[i]);
      }
    }

    while (ops.isNotEmpty) {
      values.push(applyOp(ops.pop(), values.pop(), values.pop()));
    }

    // Top of 'values' contains
    // result, return it
    return values.pop();
  }

  static bool isNumber(String value) {
    if (value == AddButton ||
        value == SubButton ||
        value == MulButton ||
        value == DivideButton) {
      return false;
    } else {
      if (value == DotButton) {
        return true;
      }
      if (int.parse(value) >= 0 && int.parse(value) <= 9) {
        return true;
      }

      return false;
    }
  }

  static bool isOperator(String value) {
    if (value == AddButton ||
        value == SubButton ||
        value == MulButton ||
        value == DivideButton) {
      return true;
    } else {
      return true;
    }
  }

  static bool hasPrecedence(String currentValue, String topValue) {
    if (((currentValue == MulButton || currentValue == DivideButton) &&
        (topValue == AddButton || topValue == SubButton)))
      return false;
    else
      return true;
  }

  static num applyOp(String op, num b, num a) {
    switch (op) {
      case AddButton:
        return a + b;
      case SubButton:
        return a - b;
      case MulButton:
        return a * b;
      case DivideButton:
        double value = a / b;
        return value;
    }
    return 0;
  }
}
