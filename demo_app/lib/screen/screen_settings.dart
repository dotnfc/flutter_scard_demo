// SPDX-License-Identifier: MIT License
//
// screen/page settings
// 

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_scard_demo/src/global.dart';
import 'package:flutter_scard_demo/screen/screen_pcsc_reader_list.dart';
import 'package:flutter_scard_demo/utils/qwicons.dart';


class ScreenSettings extends StatefulWidget {
  const ScreenSettings({super.key});

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //return const Placeholder();

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 242, 242, 242),
        ),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: <Widget> [
              buildOtherInfoWidget(),
              buildOtherInfoText(),
              const SizedBox(height: 10),
              const Divider(
                height: 1.0, 
                color: Colors.grey, 
              ),

              ...buildReaderList()
        ])));
  }
  
  buildOtherInfoWidget() {
    return InkWell(
      onTap: () {},
      child: const Stack(
        children: [
          SizedBox(
            width: 128,
            height: 128,
            child: Icon(QWIcons.icoUsb, size: 128, color: Colors.blue),
          ),
        ]));
  }
  
  buildOtherInfoText() {
    String text = "Reader Settings";
    return Text(text);
  }

  List<Widget> buildReaderList() {
    if (Platform.isWindows) {
      return <Widget>[
          const SizedBox(height: 10), 
          Card(
            elevation: 5,
            child: ListTile(
                leading: const Icon(QWIcons.icoUsbdrive),
                visualDensity: const VisualDensity(vertical: -4),
                title: const Text("Reader Name:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(Global.readerName),
                trailing: const MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Icon(Icons.chevron_right_outlined)),
                onTap: () => selectPcscReader(context)))
      ];
    }
    else if (Platform.isAndroid) {
      return <Widget>[
        const SizedBox(height: 10), 
        const Card(
          elevation: 5,
          child: ListTile(
            visualDensity: const VisualDensity(vertical: -4),
            title: Text("Reader Name:", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Android NFC"),
            //trailing: const MouseRegion(cursor: SystemMouseCursors.click, child: Icon(Icons.chevron_right_outlined)),
          )
        )
      ];
    }
    else {
      return <Widget>[Container()];
    }
  }

  void selectPcscReader (BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PcscListPage(),
      ),
    );

    if ((result != null) && mounted) {
      setState(() {
        Global.readerName = result;
      });
    }
  }

  ///
  void showMsg(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg)
    ));
  }
}
