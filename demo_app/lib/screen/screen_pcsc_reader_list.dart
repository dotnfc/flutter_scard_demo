// SPDX-License-Identifier: MIT License
//
// screen/page to select a pcsc reader
// 

import 'package:flutter/material.dart';
import 'package:flutter_pcsc/flutter_pcsc.dart';

class PcscListPage extends StatefulWidget {

  const PcscListPage({super.key});
  
  @override
  State<PcscListPage> createState() => _PcscListPageState();
}

class _PcscListPageState extends State<PcscListPage> {
  final String _title = "PCSC Reader List";
  late  List<String> _listReaders;
  bool _isLoading = true;

  @override
  void initState () {
    super.initState();
    listReaders();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: _isLoading? 
        const Center(child: CircularProgressIndicator()) :
        showReaderLists(),
    );
  }

  void listReaders() async{
    int ctx = await Pcsc.establishContext(PcscSCope.user);
    _listReaders = await Pcsc.listReaders(ctx);
    _isLoading = false;
    if (mounted) {
      setState(() {
      });
    }
  }

  Widget showReaderLists() {    
    return Card(
        margin: const EdgeInsets.all(5),
        child: ListView.separated(
          
          itemCount: _listReaders.length, // Double the itemCount to account for the separators
          itemBuilder: (context, index) {
            
            return ListTile(
              //visualDensity: const VisualDensity(vertical: -3),
              title: Text(_listReaders[index]),
              onTap: () {
                Navigator.pop(context, _listReaders[index]);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider()
        ),
        
      );
  }
}
