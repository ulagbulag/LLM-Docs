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

  void save() {
    for (final node in nodes) {
      print(node.expaned);
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

  void checkNode(bool isChecked, TreeNodeData parent) {
    parent.checked = isChecked;
    parent.extra.isChecked = isChecked;
  }

  void collpaseNode(TreeNodeData parent) {
    parent.expaned = false;
  }

  void expandNode(TreeNodeData parent) {
    parent.expaned = true;
  }

  void focusNode(TreeNodeData parent) {
    selectedNode = parent.extra;
    notifyListeners();
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
