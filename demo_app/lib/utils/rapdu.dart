import 'package:flutter_scard_demo/utils/string_convert.dart';

class RApdu {
  late String rawData = "6F00"; // all response data '009000'
  int statusCode = 0x6F00;
  List<int>? dataBytes;
  String dataHex = "";          // response data only, without SW

  RApdu(String? rapdu) {
    if (rapdu != null && rapdu.isNotEmpty) {
      rawData = rapdu;
    }
    _parseData();
  }

  void _parseData() {
    String swHex = rawData.substring(rawData.length - 4);
    statusCode = int.parse(swHex, radix: 16);

    if (rawData.length > 4) {
      dataHex = rawData.substring(0, rawData.length - 4);
      dataBytes = utilHexStringToBytes(dataHex);
    }
  }

  int get sw {
    return statusCode;
  }

  int get sw1 {
    return (statusCode & 0xff00 ) >> 8;
  }

  int get sw2 {
    return (statusCode & 0xff);
  }

  List<int>? get data {
    return dataBytes;
  }
}