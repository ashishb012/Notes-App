import 'package:flutter/material.dart';
import 'package:my_notes/services/firebase_cloud/cloud_note.dart';
import 'package:my_notes/utilities/dailogs/delete_dailog.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return Padding(
          padding: const EdgeInsets.only(left: 2.0, bottom: 5.0, right: 2.0),
          child: ListTile(
            onLongPress: () {
              // BottomAppBar();
            },
            onTap: () {
              onTap(note);
            },
            title: Text(
              note.title,
              style: DefaultTextStyle.of(context).style.apply(
                    fontSizeFactor: 1.2,
                    fontWeightDelta: 10,
                  ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDailog(context);
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
              icon: const Icon(Icons.delete_outline),
            ),
          ),
        );
      },
    );
  }
}
