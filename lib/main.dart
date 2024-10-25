// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:language_utility/Overlay.dart';

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
    OverlayWidget()
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
                        {
                          FlutterOverlayWindow.showOverlay(height: 100,width: 100)
                        }
                    },
                child: Text("press me"))
          ],
        ),
      ),
    );
  }
}
