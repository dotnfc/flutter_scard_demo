import 'package:flutter/material.dart';
import 'package:flutter_pcsc/flutter_pcsc.dart';
import 'package:flutter_scard_demo/utils/rapdu.dart';

import 'reader.dart';

class PcscReader  implements Reader {
  String _strError = "";
  CardStruct pcscCard = CardStruct(-1, PcscProtocol.undefined, "");
  int pcscCtx = -1;
  bool _bConnected = false;

  @override
  Future<bool> connect(String readerName, {bool useEscape = false}) async{
    try {
      if (_bConnected) {
        await disconnect();
      }
      pcscCtx = await Pcsc.establishContext(PcscSCope.user);

      if (useEscape) {
        pcscCard = await Pcsc.cardConnect(pcscCtx, readerName, PcscShare.direct, PcscProtocol.undefined);
      }
      else {
        pcscCard = await Pcsc.cardConnect(pcscCtx, readerName, PcscShare.shared, PcscProtocol.any);
      }
      _strError = "";
      _bConnected = true;
      return true;
    }
    catch (ex)
    {
      _strError = "$ex";
    }

    _bConnected = false;
    return false;
  }

  @override
  Future<void> disconnect() async {
    if (pcscCard.hCard != -1) {
      await Pcsc.cardDisconnect(pcscCard.hCard, PcscDisposition.unpowerCard); // resetCard
      pcscCard = CardStruct(-1, PcscProtocol.undefined, "");
    }

    if (pcscCtx != -1) {
      await Pcsc.releaseContext(pcscCtx);
      pcscCtx = -1;
    }
    _bConnected = false;
  }

  @override
  Future<String> reset(bool cold) async {
    List<int> listATR = await Pcsc.reset(pcscCard, cold);
    String sATR = listATR
        .map((i) => i.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(' ');

    return sATR;
  }

  @override
  Future<RApdu> transmit(String capdu, int timeout) async {
    String strRapdu = "";
    
    try {
      debugPrint("[nfc] => $capdu");
      var response = await Pcsc.transmit(pcscCard, hexStringToList(capdu));
      strRapdu = listToHexString(response);
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
  Future<RApdu> escape(String capdu, int timeout) async {
    String strRapdu = "";
    
    try {
      debugPrint("[nfc] => $capdu");
      var response = await Pcsc.escape(pcscCard, hexStringToList(capdu));
      strRapdu = listToHexString(response);
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

  // "11223344" => [0x11, 0x22, 0x33, 0x44]
  List<int> hexStringToList(String inputString) {
    List<int> result = [];

    String hexString = inputString.replaceAll(' ', '');
    if (hexString.length % 2 != 0) {
      throw Exception('Sanitized input string must have an even number of characters.');
    }

    for (int i = 0; i < hexString.length; i += 2) {
      String hex = hexString.substring(i, i + 2);
      int byte = int.parse(hex, radix: 16);
      result.add(byte);
    }
    return result;
  }

  // [0x11, 0x22, 0x33, 0x44] => "11223344"
  String listToHexString(List<int> intList) {
    return intList.map((int byte) {
      return byte.toRadixString(16).padLeft(2, '0');
    }).join();
  }
}
