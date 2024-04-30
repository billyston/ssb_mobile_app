import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumericKeypad extends StatelessWidget {
  final TextEditingController pinController;
  final Function onChange;

  const NumericKeypad({required this.pinController, required this.onChange, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildButton('1'),
            _buildButton('2'),
            _buildButton('3'),
          ],
        ),
        Row(
          children: [
            _buildButton('4'),
            _buildButton('5'),
            _buildButton('6'),
          ],
        ),
        Row(
          children: [
            _buildButton('7'),
            _buildButton('8'),
            _buildButton('9'),
          ],
        ),
        Row(
          children: [
            _buildButton(''),
            _buildButton('0'),
            _buildButton('⌫', onPressed: _backspace),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(String text, {VoidCallback? onPressed}) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed ?? () => _input(text),
        child: Text(text,
          style: TextStyle(fontSize: 30.sp,
              color: Colors.black,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void _input(String text) {
    if (pinController.text.length <= 5) {
      pinController.text = pinController.text + text;
      onChange(pinController.text);
    }
  }

  void _backspace() {
    if (pinController.text.isNotEmpty) {
      pinController.text = pinController.text.substring(0, pinController.text.length - 1);
    }
    if (pinController.text.length > 7) {
      pinController.text = pinController.text.substring(0, 6);
    }
    onChange(pinController.text);
  }
}

/*class NumericKeypad extends StatefulWidget {
  final TextEditingController pinController;
  final Function onChange;
  final Function onSubmit;
  const NumericKeypad({required this.pinController, required this.onChange, required this.onSubmit, Key? key}) : super(key: key);

  @override
  State<NumericKeypad> createState() => _NumericKeypadState();
}

class _NumericKeypadState extends State<NumericKeypad> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    controller.addListener(onTextChanged);
  }

  @override
  void dispose() {
    controller.removeListener(onTextChanged);
    super.dispose();
  }

  void onTextChanged() {
    final text = controller.text;
    if (text.isNotEmpty) {
      widget.onDigitEntered?.call(text.substring(text.length - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildButton('1'),
            _buildButton('2'),
            _buildButton('3'),
          ],
        ),
        Row(
          children: [
            _buildButton('4'),
            _buildButton('5'),
            _buildButton('6'),
          ],
        ),
        Row(
          children: [
            _buildButton('7'),
            _buildButton('8'),
            _buildButton('9'),
          ],
        ),
        Row(
          children: [
            _buildButton(''),
            _buildButton('0'),
            _buildButton('⌫', onPressed: _backspace),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(String text, {VoidCallback? onPressed}) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed ?? () => _input(text),
        child: Text(text,
          style: TextStyle(fontSize: 30.sp, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void _input(String text) {
    if (pinController.text.length <= 3) {
      pinController.text = pinController.text + buttonText;
      onChange(pinController.text);
    }
  }

  void _backspace() {
    final value = controller.text;
    if (value.isNotEmpty) {
      controller.text = value.substring(0, value.length - 1);
    }
  }
} */
