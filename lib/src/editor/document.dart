import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:llmdocs/src/editor/node.dart';

import 'controller.dart';

final class EditorDocumentView extends StatefulWidget {
  const EditorDocumentView({
    super.key,
    required this.controller,
    this.save,
  });

  final EditorController controller;

  final void Function()? save;

  @override
  State<StatefulWidget> createState() => EditorDocumentState();
}

final class EditorDocumentState extends State<EditorDocumentView> {
  late EditorNode rootNode;

  @override
  void initState() {
    super.initState();

    rootNode = widget.controller.rootNode;
    widget.controller.addListener(() {
      setState(() {
        rootNode = widget.controller.rootNode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TreeView.indexTyped<void, EditorNode>(
      tree: rootNode,
      builder: (context, item) => ListTile(
        title: Text(item.title),
      ),
      expansionBehavior: ExpansionBehavior.snapToTop,
      focusToNewNode: true,
      indentation: const Indentation(
        style: IndentStyle.squareJoint,
      ),
      onItemTap: widget.controller.focusNode,
      showRootNode: false,
      // append: widget.controller.addNode,
      // data: nodes,
      // onCheck: widget.controller.checkNode,
      // onCollapse: widget.controller.collpaseNode,
      // onExpand: widget.controller.expandNode,
      // onTap: widget.controller.focusNode,
      // onRemove: widget.controller.removeNode,
      // showActions: true,
      // showCheckBox: true,
      // showFilter: true,
    );
  }
}
