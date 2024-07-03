// SPDX-License-Identifier: MIT License
//
// screen/page to gp card status
// 

import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:flutter_scard_demo/gp/card_gp_status.dart';


class ScreenGPStatus extends StatefulWidget {
  final GPStatus gpStatus;

  const ScreenGPStatus({
    super.key,
    required this.gpStatus
  });

  @override
  State<ScreenGPStatus> createState() => _ScreenGPStatusState();
}

class _ScreenGPStatusState extends State<ScreenGPStatus> {

    late final TreeController<GPNode> treeController;
    
  @override
  void initState() {
    super.initState();

    treeController = TreeController<GPNode>(
      defaultExpansionState: true,
      roots: [],
      childrenProvider: (GPNode node) => node.children,
    );
  }

  @override
  void dispose() {
    super.dispose();
    treeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    treeController.roots = widget.gpStatus.statusNodes;
    
    return 
      Scaffold(
        appBar: AppBar(
          title: const Text('GP Card Status'),
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Expanded(
              child: TreeView<GPNode>(
                treeController: treeController,
                nodeBuilder: (BuildContext context, TreeEntry<GPNode> entry) {
                  return GPStatusTreeTile(
                    key: ValueKey(entry.node),
                    entry: entry,
                    onTap: () => treeController.toggleExpansion(entry.node),
                  );
                },
              )
            ),
          ],
        )
    );
  }
}
