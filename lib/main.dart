import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

enum _Operator { add, subtract, multiply, divide }

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';
  double? _storedValue;
  _Operator? _pendingOperator;
  bool _shouldResetDisplay = false;
  bool _hasError = false;

  void _inputDigit(String digit) {
    setState(() {
      if (_hasError || _shouldResetDisplay) {
        _display = digit;
        _shouldResetDisplay = false;
        _hasError = false;
      } else if (_display == '0') {
        _display = digit;
      } else {
        _display = _display + digit;
      }
    });
  }

  void _inputDecimal() {
    setState(() {
      if (_hasError || _shouldResetDisplay) {
        _display = '0.';
        _shouldResetDisplay = false;
        _hasError = false;
      } else if (!_display.contains('.')) {
        _display = '$_display.';
      }
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _storedValue = null;
      _pendingOperator = null;
      _shouldResetDisplay = false;
      _hasError = false;
    });
  }

  String _formatResult(double value) {
    if (value.isInfinite || value.isNaN) return 'Error';
    if (value == value.roundToDouble() && value.abs() < 1e15) {
      return value.toInt().toString();
    }
    String text = value.toString();
    if (text.contains('.')) {
      text = text.replaceFirst(RegExp(r'0+$'), '');
      text = text.replaceFirst(RegExp(r'\.$'), '');
    }
    return text;
  }

  double _applyOperator(double a, double b, _Operator op) {
    switch (op) {
      case _Operator.add:
        return a + b;
      case _Operator.subtract:
        return a - b;
      case _Operator.multiply:
        return a * b;
      case _Operator.divide:
        return a / b;
    }
  }

  void _chooseOperator(_Operator op) {
    setState(() {
      if (_hasError) return;
      final current = double.parse(_display);
      if (_storedValue != null && !_shouldResetDisplay) {
        final result = _applyOperator(_storedValue!, current, _pendingOperator!);
        if (result.isInfinite || result.isNaN) {
          _display = 'Error';
          _hasError = true;
          _storedValue = null;
          _pendingOperator = null;
          _shouldResetDisplay = true;
          return;
        }
        _storedValue = result;
        _display = _formatResult(result);
      } else {
        _storedValue = current;
      }
      _pendingOperator = op;
      _shouldResetDisplay = true;
    });
  }

  void _equals() {
    setState(() {
      if (_hasError || _storedValue == null || _pendingOperator == null) return;
      final current = double.parse(_display);
      final result = _applyOperator(_storedValue!, current, _pendingOperator!);
      if (result.isInfinite || result.isNaN) {
        _display = 'Error';
        _hasError = true;
      } else {
        _display = _formatResult(result);
      }
      _storedValue = null;
      _pendingOperator = null;
      _shouldResetDisplay = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomRight,
                  child: Text(
                    _display,
                    key: const Key('display'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 72,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('C', onTap: _clear, background: Colors.grey.shade700),
                          _buildButton('÷', onTap: () => _chooseOperator(_Operator.divide), background: colorScheme.primary),
                          _buildButton('×', onTap: () => _chooseOperator(_Operator.multiply), background: colorScheme.primary),
                          _buildButton('−', onTap: () => _chooseOperator(_Operator.subtract), background: colorScheme.primary),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('7', onTap: () => _inputDigit('7')),
                          _buildButton('8', onTap: () => _inputDigit('8')),
                          _buildButton('9', onTap: () => _inputDigit('9')),
                          _buildButton('+', onTap: () => _chooseOperator(_Operator.add), background: colorScheme.primary),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('4', onTap: () => _inputDigit('4')),
                          _buildButton('5', onTap: () => _inputDigit('5')),
                          _buildButton('6', onTap: () => _inputDigit('6')),
                          _buildButton('=', onTap: _equals, background: colorScheme.primary),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('1', onTap: () => _inputDigit('1')),
                          _buildButton('2', onTap: () => _inputDigit('2')),
                          _buildButton('3', onTap: () => _inputDigit('3')),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('0', onTap: () => _inputDigit('0'), flex: 2),
                          _buildButton('.', onTap: _inputDecimal),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    String label, {
    required VoidCallback onTap,
    Color? background,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: background ?? Colors.grey.shade800,
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
            padding: EdgeInsets.zero,
            elevation: 0,
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
