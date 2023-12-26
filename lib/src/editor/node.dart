import 'package:animated_tree_view/animated_tree_view.dart';

final class EditorNode extends IndexedTreeNode<void> {
  EditorNode({
    this.text = '',
    required this.parents,
    List<EditorNode>? children,
    this.checked = false,
    required this.generated,
    this.expaned = true,
  }) {
    if (children != null) {
      addAll(children);
    }

    _updateTitle();
  }

  String text;
  bool checked;
  bool expaned;
  final bool generated;

  List<int> parents;
  String title = '';

  bool get isDocumentRoot => parents.isEmpty;

  int get nodeIndex => parents.last;

  String _generateTitle() {
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditorNode &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          parents == other.parents &&
          checked == other.checked &&
          generated == other.generated;

  @override
  int get hashCode =>
      text.hashCode ^ parents.hashCode ^ checked.hashCode ^ generated.hashCode;
}
