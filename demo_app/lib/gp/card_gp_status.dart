
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:flutter_scard_demo/gp/gpinfo.dart';
import 'package:flutter_scard_demo/utils/string_convert.dart';

// Create a class to hold your hierarchical data (optional, could be a Map or
// any other data structure that's capable of representing hierarchical data).
class GPNode {
  GPNode({
    this.title = "",
    this.children = const <GPNode>[],
    this.icon = const Icon(Icons.folder)
  });

  String title;
  final Icon icon;
  List<GPNode> children;

  reset() {
    children = <GPNode>[];
  }

  loadFromELF(List<ExecLoadFileAndModuleGPStatus> elfs) {
    reset();

    title = "Executable Load Files";
    for (var elf in elfs) {
      GPNode node = GPNode (title: elf.aid.string);
      children.add(node);
    }
  }

  loadFromApp(List<ApplicationGPStatus> apps) {
    reset();

    title = "Applications";
    for (var app in apps) {
      GPNode node = GPNode (title: app.aid.string);
      children.add(node);
      // applicationPrivilege(app.privilege[0])
      // applicationLifecycleState(app.lifeCycStat)
    }
  }
}

class AID {
  List<int> aid;
  
  AID({
    required this.aid,
  });

  int get len {
    return aid.length;
  }

  String get string {
    return utilBytesToHex(Uint8List.fromList(aid));
  }
}

class ApplicationGPStatus {
  AID aid;
  int lifeCycStat; // The ISD, SD, LoadFile, App life cycle state.
  List<int> privilege; // The ISD, SD, App privileges.

  ApplicationGPStatus(this.aid, this.lifeCycStat, this.privilege);
}

class ExecLoadFileAndModuleGPStatus {
  AID aid;
  List<AID> modules;
  int lifeCycStat;

  ExecLoadFileAndModuleGPStatus(this.aid, this.lifeCycStat, this.modules);
}

String applicationLifecycleState(int lifeCycStat) {
  String result = "";
    if ((lifeCycStat & 3) != 0)        result = "INSTALLED ";
    
    if ((lifeCycStat & 7) != 0)        result = "SELECTABLE";
    
    if ((lifeCycStat & 0x78) != 0)     result = "APP_SPECS ";
    
    if ((lifeCycStat & 0x80) != 0)     result = "LOCKED    ";

    return result;
}

String applicationPrivilege(int priv) {
  var spriv = StringBuffer();
  spriv.write("(");

  spriv.write((priv & 0x80) != 0 ? "S" : "-");  // Security Domain
  
  spriv.write((priv & 0x40) != 0 ? "V" : "-");  // DAP Verification
  
  spriv.write((priv & 0x20) != 0 ? "E" : "-");  // Delegated Management
  
  spriv.write((priv & 0x10) != 0 ? "L" : "-");  // Card Lock

  
  spriv.write((priv & 0x08) != 0 ? "T" : "-");  // Card Terminate
  
  spriv.write((priv & 0x04) != 0 ? "D" : "-");  // Card Reset
  
  spriv.write((priv & 0x02) != 0 ? "P" : "-");  // CVM Management
  
  spriv.write((priv & 0x01) != 0 ? "M" : "-");  // Mandated DAP Verification

  spriv.write(")");
  return spriv.toString();
}

List<ApplicationGPStatus> parseGPApplications(List<int> rcvBuf) {
  List<ApplicationGPStatus> listModules = [];

  for (int j = 0; j < rcvBuf.length;) {
    int aidLen = rcvBuf[j++];
    List<int> aidBytes = rcvBuf.sublist(j, j + aidLen);
    AID aid = AID(aid: aidBytes);
    j += aidLen;
    
    // The Executable Load File Life Cycle can only have one state: LOADED
    int lifeCycStat = rcvBuf[j++];
    int privilege = rcvBuf[j++];

    ApplicationGPStatus appStatus = ApplicationGPStatus(aid, lifeCycStat, [privilege]);
    listModules.add(appStatus);
  }

  return listModules;
}

List<ExecLoadFileAndModuleGPStatus> parseGPExecLoadFiles(List<int> rcvBuf) {
  List<ExecLoadFileAndModuleGPStatus> listModules = [];

  for (int j = 0; j < rcvBuf.length; j ++) {
    int aidLen = rcvBuf[j++];
    List<int> aidBytes = rcvBuf.sublist(j, j + aidLen);
    AID aid = AID(aid: aidBytes);
    j += aidLen;
    
    // The Executable Load File Life Cycle can only have one state: LOADED
    int lifeCycStat = rcvBuf[j++];

    ExecLoadFileAndModuleGPStatus execModule = ExecLoadFileAndModuleGPStatus(aid, lifeCycStat, []);
    listModules.add(execModule);
  }

  return listModules;
}

List<ExecLoadFileAndModuleGPStatus> parseGPExecLoadFilesAndModules(List<int> rcvBuf) {
  List<ExecLoadFileAndModuleGPStatus> listModules = [];

  for (int j = 0; j < rcvBuf.length;) {
    int aidLen = rcvBuf[j++];
    List<int> aidBytes = rcvBuf.sublist(j, j + aidLen);
    AID aid = AID(aid: aidBytes);
    j += aidLen;
    
    // The Executable Load File Life Cycle can only have one state: LOADED
    int lifeCycStat = rcvBuf[j ++];
    j += 1;

    List<AID> modules = [];
    int modCnt = rcvBuf[j++]; // Number of associated Executable Modules

    for (int k = 0; k < modCnt && (j < rcvBuf.length); k++) {
      int aidLenModule = rcvBuf[j++];
      List<int> aidBytesModule = rcvBuf.sublist(j, j + aidLenModule);
      AID aidModule = AID(aid: aidBytesModule);
      modules.add(aidModule);
      j += aidLenModule;
    }

    ExecLoadFileAndModuleGPStatus execModule = ExecLoadFileAndModuleGPStatus(aid, lifeCycStat, modules);
    listModules.add(execModule);
  }

  return listModules;
}

class GPStatus extends  GPInfo{
  List<GPNode> statusNodes;

  GPStatus({
    required super.title,
    this.statusNodes = const <GPNode>[]
  });

  reset () {
    statusNodes = <GPNode>[];
  }

  setApplicationsStauts (List<int> ? dataBytes) {
    if (dataBytes == null) {
      return;
    }
  
    List<ApplicationGPStatus> apps = parseGPApplications(dataBytes);
    GPNode appNode = GPNode();
    appNode.loadFromApp(apps);
    statusNodes.add(appNode);
  }

  setELFsStauts (List<int> ?dataBytes) {
    if (dataBytes == null) {
      return;
    }

    List<ExecLoadFileAndModuleGPStatus> elfs = parseGPExecLoadFiles(dataBytes);
    GPNode elfNode = GPNode();
    elfNode.loadFromELF(elfs);
    statusNodes.add(elfNode);
  }
}

// Create a widget to display the data held by your tree nodes.
class GPStatusTreeTile extends StatelessWidget {
  const GPStatusTreeTile({
    super.key,
    required this.entry,
    required this.onTap,
  });

  final TreeEntry<GPNode> entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      // Wrap your content in a TreeIndentation widget which will properly
      // indent your nodes (and paint guides, if required).
      //
      // If you don't want to display indent guides, you could replace this
      // TreeIndentation with a Padding widget, providing a padding of
      // `EdgeInsetsDirectional.only(start: TreeEntry.level * indentAmount)`
      child: TreeIndentation(
        entry: entry,
        // Provide an indent guide if desired. Indent guides can be used to
        // add decorations to the indentation of tree nodes.
        // This could also be provided through a DefaultTreeIndentGuide
        // inherited widget placed above the tree view.
        guide: const IndentGuide.connectingLines(indent: 32),
        // The widget to render next to the indentation. TreeIndentation
        // respects the text direction of `Directionality.maybeOf(context)`
        // and defaults to left-to-right.
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
          child: Row(
            children: [
              // Add a widget to indicate the expansion state of this node.
              // See also: ExpandIcon.
              FolderButton(
                isOpen: entry.hasChildren ? entry.isExpanded : null,
                onPressed: entry.hasChildren ? onTap : null,
              ),
              Text(entry.node.title),
            ],
          ),
        ),
      ),
    );
  }
}
