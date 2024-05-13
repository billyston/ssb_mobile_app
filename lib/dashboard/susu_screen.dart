import 'package:flutter/material.dart';

class SusuScreen extends StatefulWidget {
  const SusuScreen({super.key});

  @override
  State<SusuScreen> createState() => _SusuScreenState();
}

class _SusuScreenState extends State<SusuScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Susu screen',
        style: TextStyle(color: Colors.white)
      ),
    );
  }
}
