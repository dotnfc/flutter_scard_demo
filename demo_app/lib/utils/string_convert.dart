import 'dart:typed_data';

/// 15 -> '0F'
String utilIntToHex(int nVal) {
  return nVal.toRadixString(16).padLeft(2, '0').toUpperCase();
}

/// 32767 -> '07FF'
String utilShortToHex(int nVal) {
  return nVal.toRadixString(16).padLeft(4, '0').toUpperCase();
}

/// '1 2 3' -> '313233'
String utilToAnsi(String str) {
  str = str.replaceAll(' ', '');
  String transformed = str.runes.map((rune) => rune.toRadixString(16)).join('');

  return transformed;
}

List<int> utilHexStringToBytes(String hexString) {
  List<int> bytes = [];
  for (int i = 0; i < hexString.length; i += 2) {
    String hex = hexString.substring(i, i + 2);
    int byte = int.parse(hex, radix: 16);
    bytes.add(byte);
  }
  return bytes;
}

// [0x48, 0x65, 0x6c, 0x6F] => "48656c6c6f" 
String utilBytesToHex(Uint8List bytes) {
  return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
}

// "48656c6c6f" => [0x48, 0x65, 0x6c, 0x6F]
Uint8List utilHexToBytes(String hexString) {

  hexString = hexString.replaceAll(" ", "");

  int len = hexString.length;
  if (len % 2 != 0) {
    hexString = "${hexString}0";
  }

  Uint8List bytes = Uint8List((len / 2).round());
  for (int i = 0; i < len; i += 2) {
    // 将两个十六进制字符转换为一个字节
    String byteString = hexString.substring(i, i + 2);
    bytes[i ~/ 2] = int.parse(byteString, radix: 16).toUnsigned(8);
  }
  return bytes;
}
