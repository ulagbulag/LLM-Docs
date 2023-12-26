import 'package:flutter/material.dart';
import 'package:flutter_tree/flutter_tree.dart';

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
  late List<TreeNodeData> nodes;

  @override
  void initState() {
    super.initState();

    nodes = widget.controller.nodes;
    widget.controller.addListener(() {
      setState(() {
        nodes = widget.controller.nodes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TreeView(
      append: widget.controller.addNode,
      data: nodes,
      onCheck: widget.controller.checkNode,
      onCollapse: widget.controller.collpaseNode,
      onExpand: widget.controller.expandNode,
      onTap: widget.controller.focusNode,
      onRemove: widget.controller.removeNode,
      showActions: true,
      showCheckBox: true,
      showFilter: true,
    );
  }
}
