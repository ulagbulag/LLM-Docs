import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

final class EditorNode extends IndexedTreeNode<void> {
  EditorNode({
    super.key,
    this.text = '',
    required this.parents,
    List<EditorNode>? children,
    this.checked = false,
    required this.metadata,
  }) {
    if (children != null) {
      addAll(children);
    }

    _updateState();
  }

  factory EditorNode.root() => EditorNode(
        key: INode.ROOT_KEY,
        text: '/',
        parents: [],
        metadata: EditorNodeMetadata(),
      )
        ..isLastChild = true
        ..cacheChildIndices();

  bool checked;
  String text;
  EditorNodeMetadata metadata;

  List<int> parents;
  final EditorNodeState _state = EditorNodeState();

  bool get isDocumentRoot => parents.isEmpty;
  int get nodeIndex => parents.last;

  EditorNodeState get state => _state;

  EditorNode addEmpty() {
    final parents = this.parents.toList();
    if (!isRoot) {
      parents.add(children.length);
    }

    final child = EditorNode(
      parents: parents,
      checked: false,
      metadata: EditorNodeMetadata(),
    );
    add(child);
    return child;
  }

  void check(EditorNode node, {bool checked = true}) {
    node.checked = checked;
  }

  void focus({bool focused = true}) {
    state.focused = focused;
  }

  bool tryDelete() {
    if (isRoot) {
      return false;
    }

    final EditorNode parent = this.parent! as EditorNode;
    if (parent.isRoot && parent.children.length == 1) {
      return false;
    }

    super.delete();
    if (!parent.isRoot) {
      for (final (index, child)
          in parent.children.whereType<EditorNode>().indexed) {
        child._updateParentIndex(index);
      }
    }
    return true;
  }

  String _generateTitle() {
    String value = '';
    for (final parent in parents) {
      value += '${parent + 1}. ';
    }
    value += text;
    return value;
  }

  String _generateSubtitle() {
    String value = '';
    for (final parent in parents) {
      value += '${parent + 1}. ';
    }
    value += text;
    return value;
  }

  void _updateParentIndex(
    int value, {
    int? position,
  }) {
    final positionValue = position ?? parents.length - 1;
    parents[positionValue] = value;

    _updateState();

    for (final child in children.whereType<EditorNode>()) {
      child._updateParentIndex(
        value,
        position: positionValue,
      );
    }
  }

  void _updateState() {
    _state.title = _generateTitle();
    _state.subtitle = _generateSubtitle();
  }

  factory EditorNode.fromJson(Map<String, dynamic> json, {List<int>? parents}) {
    final parentsList = parents ?? [];
    return EditorNode(
      text: json['text'] ?? '',
      parents: parentsList,
      children: List<dynamic>.of(json['children'])
          .indexed
          .map(
            (tuple) => EditorNode.fromJson(
              tuple.$2,
              parents: parentsList.toList()..add(tuple.$1),
            ),
          )
          .toList(),
      checked: json['checked'] == true,
      metadata: EditorNodeMetadata.fromJson(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'children':
          children.whereType<EditorNode>().map((e) => e.toJson()).toList(),
      'checked': checked,
      'metadata': metadata.toJson(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditorNode &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          parents == other.parents &&
          checked == other.checked;

  @override
  int get hashCode => text.hashCode ^ parents.hashCode ^ checked.hashCode;
}

final class EditorNodeMetadata {
  EditorNodeMetadata({
    this.generated = false,
  });

  final bool generated;

  factory EditorNodeMetadata.fromJson(Map<String, dynamic> json) {
    return EditorNodeMetadata(
      generated: json['generated'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'generated': generated,
    };
  }
}

final class EditorNodeState extends IndexedTreeNode<void> {
  EditorNodeState({
    this.title = '',
    this.subtitle = '',
    this.focused = false,
  });

  Widget? leading;
  String title;
  String subtitle;

  bool focused;
}
