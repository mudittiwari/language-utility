// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayWidget extends StatefulWidget {
  const OverlayWidget({super.key});

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  String _clipboardData = "Clipboard is empty";
  static const platform = MethodChannel('com.example.language-utility/clipboard');
  Future<void> _copyClipboardData() async {
    try {
      final String? clipboardData =
          await platform.invokeMethod('getClipboardData');
      print("Attempting to copy overlay data...");
      if (clipboardData != null && clipboardData.isNotEmpty) {
        setState(() {
          _clipboardData = clipboardData;
        });
      } else {
        setState(() {
          _clipboardData = "Clipboard is empty";
        });
      }
    } catch (e) {
      print("Error accessing clipboard: $e");
    }
  }

  // Method to process clipboard data (optional)
  void _processData(String data) {
    // Add your processing logic here, e.g., grammar correction
    print("Processing Data: $data");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        color: Colors.transparent,
        child: Container(
          height: 200,
          width: 200,
          color: Colors.red.withOpacity(0.8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _clipboardData, // Display the clipboard data here
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              IconButton(
                icon: Icon(Icons.copy, color: Colors.white),
                onPressed: _copyClipboardData, // Call the method to copy data
              ),
            ],
          ),
        ),
      ),
    );
  }
}
