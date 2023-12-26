import 'package:flutter/material.dart';

import '../controller.dart';
import '../node.dart';

final class EditorActionsView extends StatefulWidget {
  const EditorActionsView({
    super.key,
    required this.controller,
  });

  final EditorController controller;

  @override
  State<StatefulWidget> createState() => EditorActionsState();
}

final class EditorActionsState extends State<EditorActionsView> {
  EditorNode? node;

  @override
  void initState() {
    super.initState();

    node = widget.controller.selectedNode;
    widget.controller.addListener(() {
      setState(() {
        node = widget.controller.selectedNode;
        print(node);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (node == null) {
      return const SizedBox();
    }

    return ListView(
      children: const [
        ListTile(
          title: Text('Describe'),
        ),
      ],
    );
  }
}
