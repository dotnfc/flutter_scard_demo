import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_scard_demo/src/constants.dart';
import 'package:flutter_scard_demo/utils/string_convert.dart';
import 'package:pointycastle/export.dart';

class GlobalPlatformSCP02 {
  // ignore: constant_identifier_names
  static const int BLOCK_SIZE = 8; // 3DES block size in bytes

  Uint8List performInitUpdate(Uint8List hostChallenge, Uint8List cardKey) {
    // Generate card challenge
    Uint8List cardChallenge = _generateRandomBytes(BLOCK_SIZE);

    // Concatenate host challenge and card challenge
    Uint8List combinedChallenge = Uint8List.fromList([...hostChallenge, ...cardChallenge]);

    // Perform 3DES encryption in CBC mode with zero IV
    Uint8List encryptedData = _perform3DESEncryption(combinedChallenge, cardKey, Uint8List.fromList(List.filled(BLOCK_SIZE, 0)));

    // Prepare the response data
    Uint8List responseData = Uint8List.fromList([...encryptedData, ...cardChallenge]);

    return responseData;
  }

  Uint8List performExternalAuthenticate(Uint8List hostCryptogram, Uint8List cardKey) {
    // Extract the host challenge and cryptogram from the input
    Uint8List hostChallenge = hostCryptogram.sublist(0, BLOCK_SIZE);
    Uint8List receivedCryptogram = hostCryptogram.sublist(BLOCK_SIZE);

    // Perform 3DES decryption in CBC mode with zero IV
    Uint8List decryptedData = _perform3DESDecryption(receivedCryptogram, cardKey, Uint8List.fromList(List.filled(BLOCK_SIZE, 0)));

    // Extract the received host challenge
    Uint8List receivedHostChallenge = decryptedData.sublist(0, BLOCK_SIZE);

    // Verify host challenge
    if (!listEquals(hostChallenge, receivedHostChallenge)) {
      throw Exception("Host challenge verification failed");
    }

    // Extract and return the card cryptogram
    Uint8List cardCryptogram = decryptedData.sublist(BLOCK_SIZE);
    return cardCryptogram;
  }

  Uint8List _generateRandomBytes(int length) {
    var secureRandom = SecureRandom('Fortuna')..seed(KeyParameter(Uint8List.fromList(utf8.encode('seed'))));
    return Uint8List.fromList(secureRandom.nextBytes(length));
  }

  static Uint8List _perform3DESEncryption(Uint8List input, Uint8List key, Uint8List iv) {
    var cipher = CBCBlockCipher(DESedeEngine())
      ..init(true, ParametersWithIV(KeyParameter(key), iv));
    return cipher.process(Uint8List.fromList(input));
  }

  static Uint8List _perform3DESDecryption(Uint8List input, Uint8List key, Uint8List iv) {

    var cipher = CBCBlockCipher(DESedeEngine())
      ..init(false, ParametersWithIV(KeyParameter(key), iv));
    return cipher.process(Uint8List.fromList(input));
  }
}

Uint8List randomBytes(int length) {
  var random = Random.secure();
  var values = List<int>.generate(length, (i) => random.nextInt(256));
  return Uint8List.fromList(values);
}

Uint8List convertWordArrayToUint8Array(Uint8List wordArray) {
  return wordArray;
}

/// test vector
// key: BD06F2B0FBFBE98C17CA1AA3E49A1FC9
// data: 3BB1CA3258D8CBEB5A2CCDE6701767D5
// result: 8e9fbe189e03b27aa557da2c741ba3b1
Uint8List fiscalAppletEncrypt(Uint8List key, Uint8List input) {

  BlockCipher cipher = ECBBlockCipher(AESEngine());
  cipher.init(true,KeyParameter(key));
  Uint8List encrypted = cipher.process(input);

  return encrypted;
}

String fiscalAppletEncryptString(String keyHex, String dataHex) {
  debugPrint("KeyHex: $keyHex");
  debugPrint("dataHex: $dataHex");

  // 将秘钥和数据解析为字节列表
  Uint8List keyBytes = Uint8List.fromList(parseHexString(keyHex));
  Uint8List dataBytes = Uint8List.fromList(parseHexString(dataHex));

  Uint8List resultBytes = fiscalAppletEncrypt(keyBytes, dataBytes);
  String resultString = resultBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
  
  return resultString;
}

String gpScp02BuildInitUpdateCmd() {
  String result = "8050000008 ${AppConstants.GP_HOST_CHALLENGE}";
  return result;
}

String gpScp02BuildExternalAuth(String cardResponseInitUpdate) {

  Uint8List initUpdateResponse = Uint8List.fromList(parseHexString(cardResponseInitUpdate));
  String sequence = utilBytesToHex(initUpdateResponse.sublist(12, 14));

  GPSessionKeys gpSessionKeys = GPSessionKeys(AppConstants.GP_MAC_KEY, AppConstants.GP_ENC_KEY, AppConstants.GP_DEK_KEY, sequence);

  String cardChallenge = utilBytesToHex(initUpdateResponse.sublist(12, 20));
  String cardExpected = utilBytesToHex(initUpdateResponse.sublist(20, 28));
  String hostChallengeHex = AppConstants.GP_HOST_CHALLENGE;

  String cardCalc = tripleDesEncrypt("$hostChallengeHex${cardChallenge}8000000000000000", gpSessionKeys.enc).substring(32, 48);
  String hostCalc = tripleDesEncrypt("$cardChallenge${hostChallengeHex}8000000000000000", gpSessionKeys.enc).substring(32, 48);
  
  if(cardExpected != cardCalc) {
    debugPrint("card cryptogram failed");
    return "";
  }
  
  String externalAuthenticate = "8482000010$hostCalc";
  String keystr = gpSessionKeys.cmac;
  String eaSignature = getRetailMac(keystr, externalAuthenticate, "0000000000000000");
  externalAuthenticate += eaSignature;
  debugPrint("ext-auth: $externalAuthenticate");

  return externalAuthenticate;
}


String tripleDesEncrypt(String data, String key) {
  var abData = utilHexToBytes(data);
  var abKkey = utilHexToBytes(key);

  var abResult = tripleDesCbc(abData, abKkey);

  return utilBytesToHex(abResult);
}

Uint8List tripleDesCbc(Uint8List plain, Uint8List key, {Uint8List ?iv}) {
  Uint8List edeKey = key;
  if (key.length == 16) {
      edeKey = Uint8List.fromList([...key, ...key.sublist(0, 8)]); // Key1 = Key3
  }
  iv ??= Uint8List.fromList([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]);
  // Uint8List.fromList(List.filled(16, 0))

  // 创建秘钥参数
  final keyParams = KeyParameter(edeKey);

  // 创建 CBC 模式的加密器，使用全0的IV
  final ivParams = ParametersWithIV(keyParams, iv); 
  final cbcCipher = CBCBlockCipher(DESedeEngine());
  cbcCipher.init(true, ivParams);

  final cipherText = Uint8List(plain.length);

  var offset = 0;
  while (offset < plain.length) {
    offset += cbcCipher.processBlock(plain, offset, cipherText, offset);
  }

  return cipherText;
}

Uint8List desCbc(Uint8List plain, Uint8List key, {Uint8List ?iv}) {
  Uint8List edeKey = key;
  if (key.length == 8) {
      edeKey = Uint8List.fromList([...key, ...key.sublist(0, 8)]); // Key1 = Key3
  }
  iv ??= Uint8List.fromList([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]);
  // Uint8List.fromList(List.filled(16, 0))

  // 创建秘钥参数
  final keyParams = KeyParameter(edeKey);

  // 创建 CBC 模式的加密器，使用全0的IV
  final ivParams = ParametersWithIV(keyParams, iv); 
  final cbcCipher = CBCBlockCipher(DESedeEngine());
  cbcCipher.init(true, ivParams);

  final cipherText = cbcCipher.process(plain);
  
  return cipherText;
}


String getRetailMac(String keystr, String datastr, String ivstr) {
  keystr = keystr.replaceAll(RegExp(r'\s*'), '');
  datastr = datastr.replaceAll(RegExp(r'\s*'), '');
  ivstr = ivstr.replaceAll(RegExp(r'\s*'), '');

  String datastrpadded = "${datastr}8000000000000000";
  datastrpadded =
      datastrpadded.substring(0, datastrpadded.length - (datastrpadded.length % 16));

  Uint8List key = utilHexToBytes(keystr);
  Uint8List data = utilHexToBytes(datastrpadded);
  //Uint8List iv = utilHexToBytes(ivstr);

  Uint8List mac1 = desCbc(data.sublist(0, 8), key.sublist(0, 8));
  Uint8List mac2 = tripleDesCbc(data.sublist(8, 16), key, iv: mac1.sublist(0, 8));
  String result =  utilBytesToHex(mac2.sublist(0, 8));
  return result;
}

class GPSessionKeys {
  late String cmac, rmac, dek, enc;

  GPSessionKeys (String macKey, String encKey, String dekKey, String sequence) {
    cmac = tripleDesEncrypt("0101${sequence}000000000000000000000000", macKey).substring(0, 32);
    rmac = tripleDesEncrypt("0102${sequence}000000000000000000000000", macKey).substring(0, 32);
    dek = tripleDesEncrypt("0181${sequence}000000000000000000000000", encKey).substring(0, 32);
    enc = tripleDesEncrypt("0182${sequence}000000000000000000000000", dekKey).substring(0, 32);
  }
}


// 辅助函数：将16进制字符串解析为字节列表
List<int> parseHexString(String input) {
  input = input.replaceAll(" ", "");

  List<int> result = [];
  for (int i = 0; i < input.length; i += 2) {
    String hex = input.substring(i, i + 2);
    result.add(int.parse(hex, radix: 16));
  }
  return result;
}

/*
Uint8List tripleDesCbcEncrypt(Uint8List plain, Uint8List key, Uint8List iv) {
  var cipher = DES3(Key(key)).createEncryptor(iv);
  var encrypted = cipher.process(plain);
  return Uint8List.fromList(encrypted);
}

Uint8List tripleDesCbcDecrypt(Uint8List cipher, Uint8List key, Uint8List iv) {
  var cipher = DES3(Key(key)).createDecryptor(iv);
  var decrypted = cipher.process(cipher);
  return Uint8List.fromList(decrypted);
}

Uint8List getRetailMac(String keystr, String datastr, String ivstr) {
  keystr = keystr.replaceAll(RegExp(r'\s*'), '');
  datastr = datastr.replaceAll(RegExp(r'\s*'), '');
  ivstr = ivstr.replaceAll(RegExp(r'\s*'), '');

  var datastrpadded = datastr + "8000000000000000";
  datastrpadded = datastrpadded.substring(
      0, datastrpadded.length - (datastrpadded.length % 16));
  var key = Uint8List.fromList(hex.decode(keystr));
  var data = Uint8List.fromList(hex.decode(datastrpadded));
  var iv = Uint8List.fromList(hex.decode(ivstr));

  var mac1 = desCbc(data.sublist(0, 8), key.sublist(0, 8));
  var mac2 = tripleDesCbc(data.sublist(8, 16), key, mac1.sublist(0, 8));
  return mac2.sublist(0, 8);
}

*/

