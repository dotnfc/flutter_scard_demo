import 'package:flutter_scard_demo/gp/gpinfo.dart';

class GPCplc extends  GPInfo{

  GPCplc({required super.title});
  
  void parseCpc(List<int> dataBuffer) {
    items = [];

    if (dataBuffer.length < 3) {
      throw "invalid length";
    }

    if ((dataBuffer[0] != 0x9F) || (dataBuffer[1] != 0x7F)) {
      throw "invalid tag";
    }

    if ((dataBuffer[2] != 0x2A)) {
      throw "invalid length";
    }

    //StringBuffer sb = StringBuffer();
    addItem("IC Fabricator", "${aSHA(dataBuffer, 3, 2, false, "")} (${icFabricatorStr(dataBuffer, 3)})");
    addItem("IC Type", "${aSHA(dataBuffer, 5, 2, false, "")} (${ictypestr(dataBuffer, 5)})");
    addItem("Operating System ID", aSHA(dataBuffer, 7, 2, false, ""));
    addItem("Operating System release date", "${aSHA(dataBuffer, 9, 2, false, "")}${datestr(dataBuffer, 9)}");
    addItem("Operating System release level", aSHA(dataBuffer, 11, 2, false, ""));
    addItem("IC Fabrication Date", "${aSHA(dataBuffer, 13, 2, false, "")}${datestr(dataBuffer, 13)}");
    addItem("IC Serial Number", aSHA(dataBuffer, 15, 4, false, ""));
    addItem("IC Batch Identifier", aSHA(dataBuffer, 19, 2, false, ""));
    addItem("IC Module Fabricator", aSHA(dataBuffer, 21, 2, false, ""));
    addItem("IC Module Packaging Date", "${aSHA(dataBuffer, 23, 2, false, "")}${datestr(dataBuffer, 23)}");
    addItem("ICC Manufacturer", aSHA(dataBuffer, 25, 2, false, ""));
    addItem("IC Embedding Date", "${aSHA(dataBuffer, 27, 2, false, "")}${datestr(dataBuffer, 27)}");
    addItem("IC Pre-Personalizer", aSHA(dataBuffer, 29, 2, false, ""));
    addItem("IC Pre-Perso. Equipment Date", "${aSHA(dataBuffer, 31, 2, false, "")}${datestr(dataBuffer, 31)}");
    addItem("IC Pre-Perso. Equipment ID", aSHA(dataBuffer, 33, 4, false, ""));
    addItem("IC Personalizer", aSHA(dataBuffer, 37, 2, false, ""));
    addItem("IC Personalization Date", "${aSHA(dataBuffer, 39, 2, false, "")}${datestr(dataBuffer, 39)}");
    addItem("IC Perso. Equipment ID", aSHA(dataBuffer, 41, 4, false, ""));
  }

  String aSHA(List<int> paramArrayOfByte, int paramInt1, int paramInt2, bool paramBoolean, String paramString) {
    StringBuffer str = StringBuffer();

    if (paramInt2 == 0) return "";

    for (int i = 0; i < paramInt2 - 1; ++i) {
      str.write(paramArrayOfByte[i + paramInt1].toRadixString(16).padLeft(2, '0'));
      if (paramBoolean) str.write(' ');
      if (i % 16 == 15) str.write(paramString);
    }

    str.write(paramArrayOfByte[paramInt1 + paramInt2 - 1].toRadixString(16).padLeft(2, '0'));

    return str.toString();
  }

  String icFabricatorStr(List<int> abyte0, int offset) {
    String str = "unknown";
    int usID = (abyte0[offset] << 8) + abyte0[offset + 1];
    List<Map<String, dynamic>> icTypes = [
      {"id": 0x008C, "desc": "THD"},
      {"id": 0x3060, "desc": "Renesas"}, // http://www.cryptsoft.com/fips140/unpdf/140sp749-11.html
      {"id": 0x4090, "desc": "Infineon"},
      {"id": 0x4180, "desc": "Atmel"}, // https://github.com/yinheli/javaemvreader/blob/master/src/main/java/sasc/smartcard/app/globalplatform/CPLC.java
      {"id": 0x4250, "desc": "Samsung"}, // https://github.com/yinheli/javaemvreader/blob/master/src/main/java/sasc/smartcard/app/globalplatform/CPLC.java
      {"id": 0x4790, "desc": "NXP(JCOP)"},
      {"id": 0x4750, "desc": "STM"},
    ];

    for (var icType in icTypes) {
      if (icType["id"] == usID) {
        str = icType["desc"];
        break;
      }
    }

    return str;
  }

  String ictypestr(List<int> abyte0, int offset) {
    String str = "unknown";
    int usID = (abyte0[offset] << 8) + abyte0[offset + 1];

    List<Map<String, dynamic>> icTypes = [
      {"id": 0x8617, "desc": "JCOP10 v2.0 16K"},
      {"id": 0x8633, "desc": "JCOP10 v2.0 32K"},
      {"id": 0x5107, "desc": "JCOP10 36K"},
      {"id": 0x5106, "desc": "JCOP10 18K"},
      {"id": 0x5205, "desc": "JCOPS10 10K"},
      {"id": 0x8509, "desc": "JCOP20 v2.0 8K"},
      {"id": 0x8517, "desc": "JCOP20 v2.0 16K"},
      {"id": 0x8533, "desc": "JCOP20 v2.0 32K"},
      {"id": 0x5016, "desc": "JCOP21 72K"},
      {"id": 0x5114, "desc": "JCOP21 36K"},
      {"id": 0x5113, "desc": "JCOP21 18K"},
      {"id": 0x5212, "desc": "JCOPS20 10K"},
      {"id": 0x9516, "desc": "JCOP30 v2.0 16K"},
      {"id": 0x5219, "desc": "JCOPS30 12K"},
      {"id": 0x5021, "desc": "JCOP31 72K"},
      {"id": 0x5015, "desc": "JCOP31 36K"},
      {"id": 0x5025, "desc": "JCOP31 72K"},
      {"id": 0x5017, "desc": "JCOP41 72K"},
    ];

    for (var icType in icTypes) {
      if (icType["id"] == usID) {
        str = icType["desc"];
        break;
      }
    }

    return str;
  }

  String datestr(List<int> abyte0, int i) {
    StringBuffer str = StringBuffer();
    int j = (abyte0[i] >> 4) & 0xf;
    int k = (abyte0[i] & 0xf) * 100 + ((abyte0[i + 1] >> 4) & 0xf) * 10 + (abyte0[i + 1] & 0xf);

    if (k < 1 || k > 366) return "";

    k += (30 + j - 3) ~/ 4; // calculating additional days for leap years
    int yyddmm = 365 * (30 + j) + k; // since 1970-1-1
    yyddmm *= 24 * 3600;

    DateTime tt = DateTime.fromMillisecondsSinceEpoch(yyddmm * 1000, isUtc: true);
    str.write(" (${tt.year}-${tt.month.toString().padLeft(2, '0')}-${tt.day.toString().padLeft(2, '0')})");

    return str.toString();
  }
}
