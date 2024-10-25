// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:language_utility/Overlay.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure permissions are requested or already granted
  if (!await FlutterOverlayWindow.isPermissionGranted()) {
    await FlutterOverlayWindow.requestPermission();
  }
  await initializeService();
  runApp(const MyApp());
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(OverlayWidget());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  // Configure the background service
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // This will be executed when the app is in the background
      onStart: onStart,

      // Automatically start the service
      autoStart: true,

      // No foreground service settings needed
      isForegroundMode: false,
    ),
    iosConfiguration: IosConfiguration(
      // Automatically start service on iOS as well if needed
      autoStart: true,

      // No need for onForeground or onBackground in this case since we're not using foreground services
    ),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // Listen for the 'copyClipboard' event
  service.on('copyClipboard').listen((event) async {
    // Access clipboard data when the button is clicked in the overlay
    ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null && clipboardData.text != null) {
      // Process your clipboard data here
      print("Clipboard Data on Button Click: ${clipboardData.text}");
      // You can also send this data back to the main app if needed
      service.invoke('updateClipboardData', {"data": clipboardData.text});
    } else {
      print("Clipboard is empty on Button Click.");
    }
  });

  // You can add other background processing tasks here if needed
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String _clipboardData = "Clipboard is empty";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupOverlayListener(); // Move listener setup here
  }

  void _setupOverlayListener() {
    print("setting listener");
    FlutterOverlayWindow.overlayListener.listen((event) {
      print("Overlay Event: $event");
      // You can add logic to handle different types of events if needed
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      FlutterOverlayWindow.showOverlay(
          height: 200, width: 500, enableDrag: true);
      await Future.delayed(const Duration(seconds: 2));
      await FlutterOverlayWindow.shareData("copy_clipboard_data");
    } else if (state == AppLifecycleState.resumed) {
      if (await FlutterOverlayWindow.isActive()) {
        FlutterOverlayWindow.closeOverlay();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> _copyClipboardData() async {
    try {
      ClipboardData? clipboardData = await Clipboard.getData('text/plain');
      print("Attempting to copy overlay data...");
      if (clipboardData != null && clipboardData.text != null) {
        setState(() {
          _clipboardData = clipboardData.text!;
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Main App"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_clipboardData),
            TextButton(
              onPressed: _copyClipboardData,
              child: Text("Copy Clipboard Data"),
            ),
          ],
        ),
      ),
    );
  }
}
