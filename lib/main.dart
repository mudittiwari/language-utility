// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Future<bool> permisson = FlutterOverlayWindow.isPermissionGranted();
  permisson.then((value) => {print(value)});
  if (!await FlutterOverlayWindow.isPermissionGranted()) {
    print("hello world");
    FlutterOverlayWindow.requestPermission();
  }
  runApp(const MyApp());
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent, // Make the background transparent
        body: Center(
          child: Container(
            width: 100, // Circle diameter
            height: 100, // Circle diameter
            decoration: BoxDecoration(
              color: Colors.blue, // Circle color
              shape: BoxShape.circle, // Shape as a circle
            ),
          ),
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar.new(
          title: Text("this is appbar"),
        ),
        body: Column(
          children: [
            TextButton(
                onPressed: () async => {
                      if (await FlutterOverlayWindow.isActive())
                        {FlutterOverlayWindow.closeOverlay()}
                      else
                        {FlutterOverlayWindow.showOverlay()}
                    },
                child: Text("press me"))
          ],
        ),
      ),
    );
  }
}
