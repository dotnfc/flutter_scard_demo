// SPDX-License-Identifier: MIT License
//
// screen/page to show cplc
// 

import 'package:flutter/material.dart';
import 'package:flutter_scard_demo/gp/card_gp_cplc.dart';
import 'package:flutter_scard_demo/gp/gpinfo.dart';


class ScreenGPCplc extends StatefulWidget {
  final GPCplc cplc;

  const ScreenGPCplc({
    super.key,
    required this.cplc
  });

  @override
  State<ScreenGPCplc> createState() => _ScreenGPCplcState();
}

class _ScreenGPCplcState extends State<ScreenGPCplc> {

  final ScrollController _scrollController = ScrollController(initialScrollOffset: 0);
    
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        appBar: AppBar(
          title: const Text('CPLC'),
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            buildContentsForCplc(),
          ],
        )
    );
  }

  Widget buildContentsForCplc() {

    return Expanded(
      child: Scrollbar(
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(4),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: 
                    buildContentsForCplcItems(widget.cplc)                  
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> buildContentsForCplcItems(GPInfo cplc) {
    List<Widget> contents = [
      Text(
        cplc.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      //const SizedBox(height: 3),
    ];

    contents.addAll(cplc.items.map((item) {
      return ListTile(
        title: Text(item.key),
        subtitle: Text(item.value),
      );
    }).toList());

    return contents;
  }
}
