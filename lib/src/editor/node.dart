import 'package:flutter_tree/flutter_tree.dart';

final class EditorNode extends TreeNodeData {
  EditorNode({
    this.text = '',
    super.title = '',
    required super.children,
    required this.parents,
    super.checked = false,
    required this.generated,
    super.expaned = true,
  }) {
    _updateTitle();
  }

  String text;
  final bool generated;

  List<int> parents;

  bool get isRoot => parents.isEmpty;

  int get nodeIndex => parents.last;

  String _generateTitle() {
    if (isRoot) {
      return text;
    }

    String title = '';
    for (final parent in parents) {
      title += '${parent + 1}. ';
    }
    title += text;
    return title;
  }

  void _updateTitle() {
    title = _generateTitle();
  }

  void updateParent(
    int value, {
    int? position,
  }) {
    final positionValue = position ?? parents.length - 1;
    parents[positionValue] = value;

    _updateTitle();

    for (final child in children.whereType<EditorNode>()) {
      child.updateParent(
        value,
        position: positionValue,
      );
    }
  }

  factory EditorNode.fromJson(Map<String, dynamic> json, List<int>? parents) {
    final parentsList = parents ?? [];
    return EditorNode(
      text: json['text'] ?? '',
      parents: parentsList,
      children: json['children'].indexed.map(
            (index, json) => EditorNode.fromJson(
              json,
              parentsList.toList()..add(index),
            ),
          ),
      checked: json['checked'] == true,
      expaned: json['expaned'] == true,
      generated: json['generated'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'children':
          children.whereType<EditorNode>().map((e) => e.toJson()).toList(),
      'checked': checked,
      'expaned': expaned,
      'generated': generated,
    };
  }
}
