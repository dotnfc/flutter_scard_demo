
import 'package:flutter_scard_demo/utils/rapdu.dart';

abstract class Reader {

  //
  // connect to reader
  // @param readerName name of the reader
  //
  Future<bool> connect(String readerName, {bool useEscape = false}) async {
    throw UnimplementedError();
  }

  //
  // disconnect from reader
  // 
  Future<void> disconnect() async {
    throw UnimplementedError();
  }

  //
  // reset card
  //   
  Future<String> reset(bool cold) async {
    throw UnimplementedError();
  }

  //
  // transmit apdu
  //   
  Future<RApdu> transmit(String capdu, int timeout) async {
    throw UnimplementedError();
  }

  //
  // apdu to ccid reader
  //   
  Future<RApdu> escape(String capdu, int timeout) async {
    throw UnimplementedError();
  }

  //
  // F20 usb port switch: true for OTG, false for uart
  // 
  Future<bool> usbPortSwitch(bool useOTG) async {
    throw UnimplementedError();
  }

  //
  //  get error message
  //
  String getError();
}
