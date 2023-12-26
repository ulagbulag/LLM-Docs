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
        leading: item.state.leading,
        title: Text(item.state.title),
        subtitle: Text(item.state.subtitle),
        onTap: () => widget.controller.focusNode(item),
        onFocusChange: (focused) => widget.controller.focusNode(
          item,
          focused: focused,
        ),
        textColor: item.state.focused ? Colors.white : null,
        tileColor: item.state.focused ? Colors.orange : null,
        trailing: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => widget.controller.addNode(item),
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => widget.controller.removeNode(item),
            ),
          ],
        ),
      ),
      expansionBehavior: ExpansionBehavior.snapToTop,
      focusToNewNode: true,
      indentation: const Indentation(
        style: IndentStyle.squareJoint,
      ),
      showRootNode: false,
    );
  }
}
