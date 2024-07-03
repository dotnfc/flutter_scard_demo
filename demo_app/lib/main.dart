import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scard_demo/screen/screen_gp.dart';
import 'package:flutter_scard_demo/screen/screen_settings.dart';
import 'package:flutter_scard_demo/src/global.dart';
import 'package:flutter_scard_demo/utils/qwicons.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SCard Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: Platform.isWindows ? "微软雅黑" : null,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    
  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      Global.readerName = "Android NFC";
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: const SafeArea(
                child: TabBar(
              tabs: [
                Tab(
                    icon: Icon(QWIcons.gpLogo, color: Colors.blue),
                    text: "GP"),
                Tab(
                    icon: Icon(QWIcons.icoSettingSolid, color: Colors.blue),
                    text: "Settings"),
              ],
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
            )),
          ),
          body: const TabBarView(
            children: [
              ScreenGP(),
              ScreenSettings(),
            ],
          ),
        ),
      );
  }
}
