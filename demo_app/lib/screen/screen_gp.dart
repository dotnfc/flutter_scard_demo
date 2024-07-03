// SPDX-License-Identifier: MIT License
//
// screen/page to show gp contents
// 

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_scard_demo/gp/card_crypto.dart';
import 'package:flutter_scard_demo/gp/card_gp_cplc.dart';
import 'package:flutter_scard_demo/gp/card_gp_status.dart';
import 'package:flutter_scard_demo/src/global.dart';
import 'package:flutter_scard_demo/screen/screen_gp_cplc.dart';
import 'package:flutter_scard_demo/screen/screen_gp_status.dart';
import 'package:flutter_scard_demo/utils/android_nfc_reader.dart';
import 'package:flutter_scard_demo/utils/capdu.dart';
import 'package:flutter_scard_demo/utils/pcsc_reader.dart';
import 'package:flutter_scard_demo/utils/qwicons.dart';
import 'package:flutter_scard_demo/utils/rapdu.dart';
import 'package:flutter_scard_demo/utils/reader.dart';
import 'package:flutter_scard_demo/utils/string_convert.dart';
import 'package:flutter_scard_demo/src/constants.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';


class ScreenGP extends StatefulWidget {
  const ScreenGP({super.key});

  @override
  State<ScreenGP> createState() => _ScreenGPState();
}

class _ScreenGPState extends State<ScreenGP> {

  final Reader _scReader = Platform.isAndroid? NFCReader() : PcscReader();
  final GPCplc _cplc = GPCplc(title: "CPLC");
  final GPStatus _gpStatus = GPStatus(title: "GP Status");
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scReader.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    String strNote = 'Tap the Flash Icon First';
    strNote += "\nReader: ${Global.readerName}";
    
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 242, 242, 242),
        ),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              buildGPInfoWidget(),
              buildGPInfoText(),
              const SizedBox(height: 10),
              const Divider(
                height: 1.0, // 分割线的高度
                color: Colors.grey, // 分割线的颜色
              ),
              const SizedBox(height: 10),
              buildActionTitle('Show GP Card Status', () => showGPStatusScreen(context)),
              buildActionTitle('Show CPLC', () => showGPCplcScreen(context)),
              
              const SizedBox(height: 10),
              Text(strNote,
                style: const TextStyle(
                  color: Colors.blue, // 文本颜色设置为灰色
                  fontStyle: FontStyle.italic, // 设置为斜体
                  fontSize: 12.0, // 设置较小的字号
                )
              )
        ])));
  }

  Widget buildActionTitle(title, VoidCallback onTap) {
    return Card(
      elevation: 5,
      child: ListTile(
        leading: const Icon(QWIcons.gpLogo),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      )
    );
  }

  showGPStatusScreen (BuildContext context) {
    debugPrint('Attempting to navigate to GPStatus screen...');

    MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => ScreenGPStatus(gpStatus: _gpStatus), 
        settings: RouteSettings(
                    name: '/GPStatus',
                    arguments: _gpStatus
        )
    );
    Navigator.of(context).push(route).then((value) {
      debugPrint('Navigation completed with value: $value');
    }).catchError((error) {
      debugPrint('Error during navigation: $error');
    });
  }

  showGPCplcScreen (BuildContext context) {
    MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => ScreenGPCplc(cplc: _cplc), 
        settings: RouteSettings(
                    name: '/GPCPLC',
                    arguments: _cplc
        )
    );
    Navigator.of(context).push(route).then((value) {
    });
  }

  Widget buildGPInfoWidget() {
    return InkWell(
      onTap: () =>onRefreshGPInfo(),
      child: const Stack(
        children: [
          SizedBox(
            width: 128,
            height: 128,
            child: Icon(QWIcons.gpLogo, size: 128, color: Colors.blue),
          ),

          // 右上角叠加的小图标
          //buildOverlayIcon(number),
        ],
      )
    );
  } 

  Widget buildGPInfoText() {
    String text = "Smartcard Info";
    return Text(text);
  }

  onRefreshGPInfo () async {
    ProgressDialog pd = ProgressDialog(context: context);

    pd.show(msg: "Connecting Reader"); //================================
    bool result = await _scReader.connect(Global.readerName, useEscape: false);
    if (!result) {
      pd.close();
      showMsg("Error: ${_scReader.getError()}");
      return;
    }
    RApdu rApdu = RApdu("");
    try {
      // 选应用
      pd.update(msg: "Select ISD"); //================================
      rApdu = await transmit(AppConstants.APDU_SEL_ISD, 1);
      if (rApdu.sw != 0x9000) {
        throw 'Error in connect';
      }

      await onRefreshCPLC(pd);
      await onRefreshGPStatus(pd);

      if (mounted) {
        setState(() {

        });
      }
    } catch (e) {
        showMsg("Error: ${_scReader.getError()}");
        debugPrint('$e');
    } finally {
        pd.close();
        await _scReader.disconnect();
    }
  }

  // 刷新 cplc
  onRefreshCPLC(ProgressDialog pd) async {
      RApdu rApdu = await transmit(AppConstants.APDU_GET_CPLC, 1);
      if (rApdu.sw != 0x9000) {
        throw 'Error in connect';
      }

      _cplc.parseCpc(rApdu.dataBytes ?? [0x00, 0x00, 0x00]);
  }

  // 刷新 loaded modules, instance applet
  onRefreshGPStatus(ProgressDialog pd) async {

    _gpStatus.reset();

    RApdu rApdu = RApdu("");
    try {
      pd.update(msg: "Select ISD"); //================================
      rApdu = await transmit(AppConstants.APDU_SEL_ISD, 1);
      if (rApdu.sw != 0x9000) {
        throw 'Error in connect';
      }

      pd.update(msg: "GP Init-Update"); //================================
      String strInitUpdate = gpScp02BuildInitUpdateCmd();
      rApdu = await transmit(strInitUpdate, 1);
      if (rApdu.sw != 0x9000) {
        throw 'Error in connect';
      }

      pd.update(msg: "GP Ext-Auth"); //================================
      String strExtAuth = gpScp02BuildExternalAuth(rApdu.dataHex);
      if (strExtAuth == "") {
        throw 'GP init-update failed.';
      }
      rApdu = await transmit(strExtAuth, 1);
      if (rApdu.sw != 0x9000) {
        throw 'GP ext-auth failed';
      }

      pd.update(msg: "GP Status(20)"); //================================
      rApdu = await transmit("80F2 2000 02 4F00", 5);
      if (rApdu.sw != 0x9000) {
        throw 'failed to get elf status';
      }
      _gpStatus.setELFsStauts(rApdu.dataBytes);

      pd.update(msg: "GP Status(40)"); //================================
      rApdu = await transmit("80F2 4000 02 4F00", 5);
      if (rApdu.sw != 0x9000) {
        pd.update(msg: 'failed to get applications status');
      }
      _gpStatus.setApplicationsStauts(rApdu.dataBytes);

      if (mounted) {
        setState(() {
          // treeController.roots = _gpStatus.statusNodes;
        });
      }

      showMsg("Operation success");
    } catch (e) {
        showMsg("Error: ${_scReader.getError()}");
        debugPrint('$e');
    } finally {
        await _scReader.disconnect();
    }
  }

  Future<RApdu> transmit(String capdu, int timeout) async {
    RApdu rApdu = await _scReader.transmit(capdu, timeout);
    if (rApdu.sw == 0x9000) {
      return rApdu;
    }
    else if (rApdu.sw1 == 0x61) {
      int lc = rApdu.sw2;
      rApdu = await _scReader.transmit("00c0 0000 ${utilIntToHex(lc)}", timeout);
      if (rApdu.sw == 0x9000) {
        return rApdu;
      }
    }
    else if (rApdu.sw1 == 0x6c) {
      CApdu capdu2 = CApdu(capdu);
      capdu2.P3 = rApdu.sw2;
      rApdu = await _scReader.transmit(capdu2.apdu, timeout);
      if (rApdu.sw == 0x9000) {
        return rApdu;
      }
    }

    return rApdu;
  }

  ///
  void showMsg(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg)
    ));
  }
}

