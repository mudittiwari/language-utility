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
  String _clipboardData =
      "Clipboard is empty"; // State variable to store clipboard data

  // @override
  // void initState() {
  //   super.initState();
  //   _setupOverlayListener(); // Move listener setup here
  // }

  // void _setupOverlayListener() {
  //   print("setting listener");
  //   FlutterOverlayWindow.overlayListener.listen((event) {
  //     print("Overlay Event: $event");
  //     // You can add logic to handle different types of events if needed
  //   });
  // }

  // Method to copy clipboard data and update the state
  Future<void> _copyClipboardData() async {
    print("sharing data");
    await FlutterOverlayWindow.shareData("copy_clipboard_data");
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
