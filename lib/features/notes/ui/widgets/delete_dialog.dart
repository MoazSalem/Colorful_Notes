import 'package:colorful_notes/features/notes/ui/providers/notifier_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<bool?> showDeleteNoteDialog(
  BuildContext context,
  String noteId,
  NotesNotifier notesController,
) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('DeleteN'.tr()),
      content: Text("msg".tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Cancel'.tr()),
        ),
        TextButton(
          onPressed: () async {
            await notesController.delete(noteId);
            if (context.mounted) Navigator.of(context).pop(true);
          },
          child: Text('Delete'.tr(), style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
