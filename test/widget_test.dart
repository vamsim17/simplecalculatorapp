import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:simplecalculatorapp/main.dart';

String _displayText(WidgetTester tester) {
  return tester.widget<Text>(find.byKey(const Key('display'))).data ?? '';
}

void main() {
  testWidgets('Calculator adds two numbers', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(find.widgetWithText(ElevatedButton, '2'));
    await tester.tap(find.widgetWithText(ElevatedButton, '+'));
    await tester.tap(find.widgetWithText(ElevatedButton, '3'));
    await tester.tap(find.widgetWithText(ElevatedButton, '='));
    await tester.pump();

    expect(_displayText(tester), '5');
  });

  testWidgets('Clear button resets the display', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(find.widgetWithText(ElevatedButton, '7'));
    await tester.pump();
    expect(_displayText(tester), '7');

    await tester.tap(find.widgetWithText(ElevatedButton, 'C'));
    await tester.pump();
    expect(_displayText(tester), '0');
  });

  testWidgets("Two plus two", (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

  //press 2
    await tester.tap(find.text("2").last);
    await tester.pump();

    ///press +
  await tester.tap(find.text("+").last);
  await tester.pump();

    //press 2
  await tester.tap(find.text("2").last);
  await tester.pump();

  //press 2
  await tester.tap(find.text("=").last);
  await tester.pump();
  });
}
