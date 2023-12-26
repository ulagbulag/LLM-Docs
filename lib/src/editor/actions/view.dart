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

    if (node!.isDocumentRoot) {
      return ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Build a Frame'),
            onTap: () {},
          ),
        ],
      );
    }

    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Edit'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('Describe'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.expand),
          title: const Text('Expand'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.flip_to_front),
          title: const Text('Reform'),
          onTap: () {},
        ),
      ],
    );
  }
}
