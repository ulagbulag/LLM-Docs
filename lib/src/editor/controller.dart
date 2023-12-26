import 'dart:convert';
import 'dart:io';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';

import 'node.dart';

class EditorController extends ChangeNotifier {
  EditorNode rootNode = EditorNode.root()
    ..add(EditorNode(
      text: 'hello world',
      parents: [],
      metadata: EditorNodeMetadata(),
    ));

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
        // FIXME: error handling
        final List<dynamic> fileJsonList =
            jsonDecode(await file.readAsString());
        for (final fileJson in fileJsonList) {
          final fileNode = EditorNode.fromJson(fileJson);
          rootNode.add(fileNode);
          createdDocuments++;
        }
      }

      if (createdDocuments > 0) {
        if (reset) {
          rootNode.removeAll(nodes.sublist(0, oldNodes));
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
    const encoder = JsonEncoder.withIndent('  ');
    final json = encoder
        .convert(nodes.whereType<EditorNode>().map((e) => e.toJson()).toList());
    final bytes = utf8.encode(json);

    final now = DateTime.now();
    final name =
        'document-${now.toUtc().toIso8601String().replaceAll(':', '-')}';
    final path = await FileSaver.instance.saveFile(
      name: name,
      bytes: bytes,
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
    final child = parent.addEmpty();
    notifyListeners();
    return child;
  }

  void focusNode(
    EditorNode node, {
    bool? focused,
    bool force = false,
  }) {
    if (selectedNode != null) {
      selectedNode!.focus(focused: false);
    }

    final value = focused ?? !node.state.focused;
    node.focus(focused: value);

    if (value) {
      selectedNode = node;
      notifyListeners();
    } else if (force || selectedNode == node) {
      selectedNode = null;
      notifyListeners();
    }
  }

  void removeNode(EditorNode node) {
    if (node.tryDelete()) {
      focusNode(
        node,
        focused: false,
        force: true,
      );
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
