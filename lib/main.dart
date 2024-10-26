// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:language_utility/Overlay.dart';

final GlobalKey<_MyAppState> myAppStateKey = GlobalKey<_MyAppState>();
const MethodChannel platform = MethodChannel('com.example.language-utility/clipboard');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _setupMethodChannel();
  if (!await FlutterOverlayWindow.isPermissionGranted()) {
    await FlutterOverlayWindow.requestPermission();
  }
  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "Background Task Example",
    notificationText: "Running in the background",
    notificationImportance: AndroidNotificationImportance.normal,
    enableWifiLock: true,
  );

  bool hasPermissions =
      await FlutterBackground.initialize(androidConfig: androidConfig);
  if (hasPermissions) {
    runApp(MyApp(key: myAppStateKey));
  }
}

void _setupMethodChannel() {
  platform.setMethodCallHandler((call) async {
    if (call.method == 'getClipboardData') {
      ClipboardData? clipboardData = await Clipboard.getData('text/plain');
      return clipboardData?.text ?? "Clipboard is empty";
    }
    return null;
  });
}



@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(OverlayWidget());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String _clipboardData = "Clipboard is empty";
  Timer? _timer;
  bool isRunning = false;
static const platform = MethodChannel('com.example.language-utility/clipboard');
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void startBackgroundTask() async {
    bool success = await FlutterBackground.enableBackgroundExecution();
    if (success) {
      setState(() {
        isRunning = true;
      });
      FlutterOverlayWindow.overlayListener.listen((event) {
        print("Overlay Event: $event");
        // You can add logic to handle different types of events if needed
      });
      _timer = Timer.periodic(Duration(seconds: 2), (timer) {
        print("Background task running: ${DateTime.now()}");
      });
    }
  }

  void stopBackgroundTask() async {
    _timer?.cancel();
    await FlutterBackground.disableBackgroundExecution();
    setState(() {
      isRunning = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopBackgroundTask();
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
