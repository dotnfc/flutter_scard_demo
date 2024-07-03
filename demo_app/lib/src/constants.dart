// ignore_for_file: constant_identifier_names

class AppConstants {
  static const String READER_NAME = "Aero NFC Reader 0";

  static const String APDU_SEL_ISD = "00A4040008 A000000003000000";
  static const String APDU_GET_CPLC = "80CA 9F7F 00";

  static const String APDU_SEL_APP = "00A4 0400 08 D156000132001A00";     // 选应用

  // GlobalPlatform specific
  static const String GP_HOST_CHALLENGE = '1122334455667788';
  static const String GP_DEFAULT_KEY = '404142434445464748494A4B4C4D4E4F';
  static const String GP_MAC_KEY = GP_DEFAULT_KEY; 
  static const String GP_ENC_KEY = GP_DEFAULT_KEY;
  static const String GP_DEK_KEY = GP_DEFAULT_KEY;
}
