import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:flutter_scard_demo/utils/rapdu.dart';
import 'reader.dart';

class NFCReader implements Reader {
  String _strError = "";

  @override
  Future<bool> connect(String readerName, {bool useEscape = false}) async{
    
    if (!Platform.isAndroid) {
      _strError = "only for Android";
      return false;
    }
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      _strError = "NFC is not availability";
      return false;
    }

    try {
      //_strError = "Put your device to the back of Phone to Go.";
      var tag = await FlutterNfcKit.poll(
          timeout: const Duration(seconds: 5),
          iosMultipleTagMessage: "Multiple tags found!",
          iosAlertMessage: "Scan your tag");

      debugPrint(jsonEncode(tag));
      if (tag.type == NFCTagType.iso7816) {
        _strError = "";
        return true;
      }
    }
    catch (ex)
    {
      _strError = "Error: $ex.message";
    }

    return false;
  }

  @override
  Future<RApdu> escape(String capdu, int timeout) async {
    debugPrint("[nfc] => $capdu");

    debugPrint("[nfc] <= 6F00");
    return RApdu('6F00');
  }

  @override
  Future<void> disconnect() async {
    _strError = "";
  }

 @override
  Future<String> reset(bool cold) async {
    return '3B00';
  }

  @override
  Future<RApdu> transmit(String capdu, int timeout) async {
    String strRapdu = "";
    
    try {
      capdu = capdu.replaceAll(' ', '');
      debugPrint("[nfc] => $capdu");
      strRapdu = await FlutterNfcKit.transceive(capdu, timeout: Duration(seconds: timeout));
      debugPrint("[nfc] <= $strRapdu");
    }
    catch (ex)
    {
      strRapdu = "";
      _strError = "Error: $ex.message";
    }
    _strError = "";
    return RApdu(strRapdu);
  }

  @override
  Future<bool> usbPortSwitch(bool useOTG) async {
    return true;
  }

  @override
  String getError() {
    return _strError;
  }
}
