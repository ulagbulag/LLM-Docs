import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:llmdocs/src/editor/controller.dart';

import '../settings/settings_view.dart';
import 'actions/view.dart';
import 'document.dart';

final class EditorView extends StatefulWidget {
  const EditorView({
    super.key,
  });

  static const routeName = '/';

  @override
  State<StatefulWidget> createState() => EditorState();
}

final class EditorState extends State<EditorView> {
  final EditorController controller = EditorController();

  @override
  Widget build(BuildContext context) {
    AppLocalizations vocab = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(vocab.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            tooltip: 'Load',
            onPressed: controller.loadByPrompt,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: controller.save,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(
                context,
                SettingsView.routeName,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: EditorDocumentView(
                controller: controller,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: EditorActionsView(
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
