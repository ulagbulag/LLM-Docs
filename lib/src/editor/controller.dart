import 'dart:convert';
import 'dart:io';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';

import 'node.dart';

class EditorController extends ChangeNotifier {
  EditorNode rootNode = EditorNode(
    text: '/',
    parents: [],
    children: [
      EditorNode(
        parents: [],
        children: [],
        text: 'hello world',
        generated: true,
      ),
    ],
    generated: false,
  );

  List<IndexedNode> get nodes => rootNode.children;

  EditorNode? selectedNode;

  Future<void> loadByPrompt(
    BuildContext context, {
    bool reset = true,
  }) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      allowedExtensions: ['json'],
      type: FileType.custom,
    );

    if (result != null) {
      final oldNodes = nodes.length;
      final files = result.paths.map((e) => File(e!)).toList();

      int createdDocuments = 0;
      for (final file in files) {
        final List<dynamic> fileJsonList =
            jsonDecode(await file.readAsString());
        for (final fileJson in fileJsonList) {
          final fileNode = EditorNode.fromJson(fileJson);
          nodes.add(fileNode);
          createdDocuments++;
        }
      }

      if (createdDocuments > 0) {
        if (reset) {
          nodes.removeRange(0, oldNodes);
        }

        if (context.mounted) {
          _showAlert(
            context: context,
            content: 'Loaded $createdDocuments documents.',
          );
        }
        notifyListeners();
      }
    }
  }

  Future<void> save(BuildContext context) async {
    final now = DateTime.now();
    final path = await FileSaver.instance.saveFile(
      name: 'document-${now.toUtc().toIso8601String()}',
      bytes: utf8.encode(jsonEncode(
          nodes.whereType<EditorNode>().map((e) => e.toJson()).toList())),
      ext: '.json',
      mimeType: MimeType.json,
    );

    if (context.mounted) {
      _showAlert(
        context: context,
        content: 'Saved to $path',
      );
    }
  }

  EditorNode addNode(EditorNode parent) {
    final parents = parent.parents.toList();
    if (!parent.isRoot) {
      parents.add(parent.children.length);
    }

    return EditorNode(
      parents: parents,
      children: [],
      checked: false,
      generated: true,
    );
  }

  void checkNode(EditorNode node, bool checked) {
    node.checked = checked;
  }

  void expandNode(EditorNode node, bool expaned) {
    node.expaned = expaned;
  }

  void focusNode(EditorNode node) {
    selectedNode = node;
    notifyListeners();
  }

  void removeNode(
    EditorNode node,
  ) {
    if (node.isDocumentRoot) {
      if (nodes.length == 1) {
        return;
      }
    } else if (!node.isDocumentRoot) {
      for (final (index, child)
          in node.parent!.children.whereType<EditorNode>().indexed) {
        child.updateParent(index);
      }
      notifyListeners();
    }
  }

  void _showAlert({
    required BuildContext context,
    required String content,
  }) {
    final snackBar = SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
