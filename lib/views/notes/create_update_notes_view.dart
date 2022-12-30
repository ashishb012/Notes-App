import 'package:flutter/material.dart';
import 'package:my_notes/services/auth/auth_services.dart';
import 'package:my_notes/utilities/dailogs/cannot_share_empty_note_dailog.dart';
import 'package:my_notes/utilities/generics/get_arguments.dart';
import 'package:my_notes/services/firebase_cloud/cloud_note.dart';
import 'package:my_notes/services/firebase_cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNotesView extends StatefulWidget {
  const CreateUpdateNotesView({super.key});

  @override
  State<CreateUpdateNotesView> createState() => _CreateUpdateNotesViewState();
}

class _CreateUpdateNotesViewState extends State<CreateUpdateNotesView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesServices;
  late final TextEditingController _textEditingController;
  late final TextEditingController _titleEditingController;

  @override
  void initState() {
    super.initState();
    _notesServices = FirebaseCloudStorage();
    _textEditingController = TextEditingController();
    _titleEditingController = TextEditingController();
  }

  Future<CloudNote> createOrGetNote(BuildContext context) async {
    final widgetNote = context.getArguments<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textEditingController.text = widgetNote.text;
      _titleEditingController.text = widgetNote.title;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id!;
    final newNote = await _notesServices.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfEmpty() {
    final note = _note;
    if (_textEditingController.text.isEmpty &&
        _titleEditingController.text.isEmpty &&
        note != null) {
      _notesServices.deletNote(documentId: note.documentId);
    }
  }

  void _autoSaveNote() async {
    final note = _note;
    final text = _textEditingController.text;
    final title = _titleEditingController.text;
    if (note != null && text.isNotEmpty) {
      _notesServices.updateNote(
        documentId: note.documentId,
        text: text,
        title: title,
      );
    }
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textEditingController.text;
    final title = _titleEditingController.text;
    await _notesServices.updateNote(
      documentId: note.documentId,
      text: text,
      title: title,
    );
  }

  void _setUpTextControllerListener() {
    _textEditingController.removeListener(_textControllerListener);
    _textEditingController.addListener(_textControllerListener);
    _titleEditingController.removeListener(_textControllerListener);
    _titleEditingController.addListener(_textControllerListener);
  }

  @override
  void dispose() {
    _deleteNoteIfEmpty();
    _autoSaveNote();
    _textEditingController.dispose();
    _titleEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleEditingController,
          maxLines: 1,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            hintText: "Title",
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textEditingController.text;
              if (_note == null || text.isEmpty) {
                await showCannotShareEmptyNoteDailog(context);
              } else {
                Share.share(text);
              }
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: FutureBuilder(
          future: createOrGetNote(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                snapshot.data as CloudNote;
                _setUpTextControllerListener();
                return TextField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Start Typing here...",
                    border: InputBorder.none,
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

// // Crud
// class _CreateUpdateNotesViewState extends State<CreateUpdateNotesView> {
//   DatabaseNote? _note;
//   late final NotesServices _notesServices;
//   late final TextEditingController _textEditingController;

//   @override
//   void initState() {
//     super.initState();
//     _notesServices = NotesServices();
//     _textEditingController = TextEditingController();
//   }

//   Future<DatabaseNote> createOrGetNote(BuildContext context) async {
//     final widgetNote = context.getArguments<DatabaseNote>();

//     if (widgetNote != null) {
//       _note = widgetNote;
//       _textEditingController.text = widgetNote.text;
//       return widgetNote;
//     }

//     final existingNote = _note;
//     if (existingNote != null) {
//       return existingNote;
//     }
//     final currentUser = AuthService.firebase().currentUser!;
//     final email = currentUser.email;
//     final owner = await _notesServices.getUser(email: email);
//     final newNote = await _notesServices.createNote(owner: owner);
//     _note = newNote;
//     return newNote;
//   }

//   void _deleteNoteIfEmpty() {
//     final note = _note;
//     if (_textEditingController.text.isEmpty && note != null) {
//       _notesServices.deleteNote(id: note.id);
//     }
//   }

//   void _autoSaveNote() async {
//     final note = _note;
//     final text = _textEditingController.text;
//     if (note != null && text.isNotEmpty) {
//       _notesServices.updateNote(
//         note: note,
//         text: text,
//       );
//     }
//   }

//   void _textControllerListener() async {
//     final note = _note;
//     if (note == null) {
//       return;
//     }
//     final text = _textEditingController.text;
//     await _notesServices.updateNote(
//       note: note,
//       text: text,
//     );
//   }

//   void _setUpTextControllerListener() {
//     _textEditingController.removeListener(_textControllerListener);
//     _textEditingController.addListener(_textControllerListener);
//   }

//   @override
//   void dispose() {
//     _deleteNoteIfEmpty();
//     _autoSaveNote();
//     _textEditingController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("New Note"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(5.0),
//         child: FutureBuilder(
//           future: createOrGetNote(context),
//           builder: (context, snapshot) {
//             switch (snapshot.connectionState) {
//               case ConnectionState.done:
//                 snapshot.data as DatabaseNote;
//                 _setUpTextControllerListener();
//                 return TextField(
//                   controller: _textEditingController,
//                   keyboardType: TextInputType.multiline,
//                   maxLines: null,
//                   decoration: const InputDecoration(
//                     hintText: "Start Typing here...",
//                     border: InputBorder.none,
//                   ),
//                 );
//               default:
//                 return const CircularProgressIndicator();
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
