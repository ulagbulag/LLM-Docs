import 'dart:convert';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tree/flutter_tree.dart';

import 'node.dart';

class EditorController extends ChangeNotifier {
  List<EditorNode> nodes = [
    EditorNode(
      parents: [],
      children: [],
      text: 'hello world',
      generated: true,
    ),
  ];

  EditorNode? selectedNode;

  Future<void> loadByPrompt() async {
    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    final now = DateTime.now();
    final path = await FileSaver.instance.saveFile(
      name: 'document-${now.toUtc().toIso8601String()}',
      bytes: utf8.encode(jsonEncode(nodes.map((e) => e.toJson()).toList())),
      ext: '.json',
      mimeType: MimeType.json,
    );

    if (context.mounted) {
      final snackBar = SnackBar(
        content: Text('Saved to $path'),
        duration: const Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  TreeNodeData addNode(TreeNodeData parent) {
    if (parent is! EditorNode) {
      throw Exception('Document node should be \'EditorNode\'.');
    }

    return EditorNode(
      parents: parent.parents.toList()..add(parent.children.length),
      children: [],
      checked: false,
      generated: true,
    );
  }

  void checkNode(bool isChecked, TreeNodeData node) {
    node.checked = isChecked;
  }

  void collpaseNode(TreeNodeData node) {
    node.expaned = false;
  }

  void expandNode(TreeNodeData node) {
    node.expaned = true;
  }

  void focusNode(TreeNodeData node) {
    if (node is EditorNode) {
      selectedNode = node;
      notifyListeners();
    }
  }

  void removeNode(TreeNodeData node, TreeNodeData parent) {
    if (node is EditorNode && !node.isRoot && parent is EditorNode) {
      for (final (index, child)
          in parent.children.whereType<EditorNode>().indexed) {
        child.updateParent(index);
      }
      notifyListeners();
    }
  }
}
