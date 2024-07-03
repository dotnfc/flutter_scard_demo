
// ignore_for_file: non_constant_identifier_names

import 'package:flutter_scard_demo/utils/string_convert.dart';

class CApdu {
  late String rawData = "0000000000";
  int CLA = 0;
  int INS = 0;
  int P1 = 0;
  int P2 = 0;
  int P3 = 0;

  String dataHex = "";
  List<int>? dataBytes;

  CApdu(String? capdu) {
    if (capdu != null && capdu.isNotEmpty) {
      capdu = capdu.replaceAll(" ", "");
      int paddingLength = 10 - capdu.length;
      if (capdu.length % 2 != 0) {
        paddingLength++;
      }
      rawData = capdu + '0' * paddingLength;      
    }
    else {
      rawData = "0000000000";
    }
    
    _parseData();
  }

  void _parseData() {
    String sVal = rawData.substring(0, 2);
    CLA = int.parse(sVal, radix: 16);
    
    sVal = rawData.substring(2, 4);
    INS = int.parse(sVal, radix: 16);

    sVal = rawData.substring(4, 6);
    P1 = int.parse(sVal, radix: 16);

    sVal = rawData.substring(6, 8);
    P2 = int.parse(sVal, radix: 16);

    sVal = rawData.substring(8, 10);
    P3 = int.parse(sVal, radix: 16);

    if (rawData.length > 10) {
      dataHex = rawData.substring(10, rawData.length);
      dataBytes = utilHexStringToBytes(dataHex);
    }
  }

  String get apdu {
    String sapdu = "${utilIntToHex(CLA)} ${utilIntToHex(INS)} ${utilIntToHex(P1)} ${utilIntToHex(P2)} ${utilIntToHex(P3)}";
    if (dataHex.isNotEmpty) {
      sapdu = sapdu + dataHex;
    }

    return sapdu;
  }
}