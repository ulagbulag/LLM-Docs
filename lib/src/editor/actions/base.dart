import 'package:flutter/material.dart';

abstract class EditorActionView extends StatelessWidget {
  const EditorActionView({
    super.key,
  });

  String title(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title(context)),
    );
  }
}
