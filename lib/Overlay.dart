import 'package:flutter/material.dart';

class OverlayWidget extends StatefulWidget {
  const OverlayWidget({super.key});

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Container(
          height: 100,
          width: 100,
          color: Colors.red,
          child: Text("hello world"),
        ),
      ),
    );
  }
}