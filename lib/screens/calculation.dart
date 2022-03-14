import 'package:calculator/utils/buttons.dart';
import 'package:stack/stack.dart';

class EvaluateString {
  static num evaluate(String expression) {
    final tokens = expression.split('');

    // Stack for numbers: 'values'
    Stack<num> values = new Stack<num>();

    // Stack for Operators: 'ops'
    Stack<String> ops = new Stack<String>();

    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i] == ' ') continue;

      if (isNumber(tokens[i])) {
        StringBuffer sbuf = StringBuffer();

        // There may be more than one
        // digits in number
        while (i < tokens.length && isNumber(tokens[i]))
          sbuf.write(tokens[i++]);
        values.push(num.parse(sbuf.toString()));

        i--;
      }

      // Current token is an operator.
      else if (tokens[i] == AddButton ||
          tokens[i] == SubButton ||
          tokens[i] == MulButton ||
          tokens[i] == DivideButton) {
        while (ops.isNotEmpty && hasPrecedence(tokens[i], ops.top()))
          values.push(applyOp(ops.pop(), values.pop(), values.pop()));

        // Push current token to 'ops'.
        ops.push(tokens[i]);
      }
    }

    while (ops.isNotEmpty)
      values.push(applyOp(ops.pop(), values.pop(), values.pop()));

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
      final convertInt = int.parse(value);

      if (convertInt >= 0 && convertInt <= 9) {
        return true;
      }
      return false;
    }
  }

  static bool hasPrecedence(String op1, String op2) {
    if ((op1 == MulButton || op1 == DivideButton) &&
        (op2 == AddButton || op2 == SubButton))
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
