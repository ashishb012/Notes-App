// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:path/path.dart' show join;
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// import 'package:my_notes/extentions/list/filters.dart';
// import 'package:my_notes/services/crud/crud_exceptions.dart';

// class NotesServices {
//   Database? _db;

//   List<DatabaseNote> _notes = [];

//   DatabaseUser? _user;

//   // singleton class
//   static final NotesServices _shared = NotesServices._sharedInstance();
//   NotesServices._sharedInstance() {
//     _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
//       onListen: () {
//         _notesStreamController.sink.add(_notes);
//       },
//     );
//   }
//   factory NotesServices() => _shared;

//   late final StreamController<List<DatabaseNote>> _notesStreamController;

//   Stream<List<DatabaseNote>> get allNotes =>
//       _notesStreamController.stream.filter((note) {
//         final currentUser = _user;
//         if (currentUser != null) {
//           return note.userId == currentUser.id;
//         } else {
//           throw UserShouldBeSetBeforeReadingAllNotesException();
//         }
//       });

//   Future<DatabaseUser> createOrGetUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     try {
//       final user = await getUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on UserNotFoundException {
//       final createuser = await createUser(email: email);
//       if (setAsCurrentUser) {
//         _user = createuser;
//       }
//       return createuser;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> _cachedNotes() async {
//     final allNotes = await getAllNote();
//     _notes = allNotes.toList();
//     _notesStreamController.add(_notes);
//   }

//   Future<DatabaseNote> updateNote({
//     required DatabaseNote note,
//     required String text,
//   }) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     await getNote(id: note.id);
//     final updateCount = await db.update(
//       noteTable,
//       {
//         textColumn: text,
//         isSyncedColumn: 0,
//       },
//       where: "id = ?",
//       whereArgs: [note.id],
//     );
//     if (updateCount == 0) {
//       throw CouldNotUpdateNoteException();
//     } else {
//       final updatedNote = await getNote(id: note.id);
//       _notes.removeWhere((note) => note.id == updatedNote.id);
//       _notes.add(updatedNote);
//       _notesStreamController.add(_notes);
//       return updatedNote;
//     }
//   }

//   Future<Iterable<DatabaseNote>> getAllNote() async {
//     await _ensureDbIsOpen();
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(noteTable);
//     return notes.map((note) => DatabaseNote.fromRow(note));
//   }

//   Future<DatabaseNote> getNote({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(
//       noteTable,
//       limit: 1,
//       where: "id = ?",
//       whereArgs: [id],
//     );
//     if (notes.isEmpty) {
//       throw CouldNotFindNoteException();
//     } else {
//       final note = DatabaseNote.fromRow(notes.first);
//       _notes.removeWhere((note) => note.id == id);
//       _notes.add(note);
//       _notesStreamController.add(_notes);
//       return note;
//     }
//   }

//   Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw UserNotFoundException();
//     }
//     const text = "";
//     final noteID = await db.insert(noteTable, {
//       userIdColumn: owner.id,
//       textColumn: text,
//       isSyncedColumn: 1,
//     });
//     final note = DatabaseNote(
//       id: noteID,
//       userId: owner.id,
//       text: text,
//       isSynced: true,
//     );
//     _notes.add(note);
//     _notesStreamController.add(_notes);
//     return note;
//   }

//   Future<void> deleteNote({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deleteCount = await db.delete(
//       noteTable,
//       where: "id = ?",
//       whereArgs: [id],
//     );
//     if (deleteCount == 0) {
//       throw CouldNotDeleteNoteException();
//     } else {
//       _notes.removeWhere((note) => note.id == id);
//       _notesStreamController.add(_notes);
//     }
//   }

//   Future<int> deleteAll() async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(noteTable);
//     _notes = [];
//     _notesStreamController.add(_notes);
//     return deletedCount;
//   }

//   Future<DatabaseUser> getUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: "email = ?",
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isEmpty) {
//       throw UserNotFoundException();
//     } else {
//       return DatabaseUser.fromRow(results.first);
//     }
//   }

//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: "email = ?",
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isNotEmpty) {
//       throw UserAlreadyExistsException();
//     }
//     final userID = await db.insert(
//       userTable,
//       {emailColumn: email.toLowerCase()},
//     );
//     return DatabaseUser(id: userID, email: email);
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       userTable,
//       where: "email = ?",
//       whereArgs: [email.toLowerCase()],
//     );
//     if (deletedCount != 1) {
//       throw CouldNotDeleteUserException();
//     }
//   }

//   Database _getDatabaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseNotOpenedException();
//     } else {
//       return db;
//     }
//   }

//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseNotOpenedException();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }

//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenedException();
//     }
//     try {
//       final docsPath = await getApplicationSupportDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;
//       // Create user table
//       await db.execute(createUserTable);
//       // Create note table
//       await db.execute(createNoteTable);
//       await _cachedNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentsDirectoryException();
//     }
//   }

//   Future<void> _ensureDbIsOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenedException {
//       //
//     }
//   }
// }

// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;

//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });

//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;
//   @override
//   String toString() => "Person, ID: $id, email: $email";

//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// class DatabaseNote {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSynced;

//   DatabaseNote({
//     required this.id,
//     required this.userId,
//     required this.text,
//     required this.isSynced,
//   });

//   DatabaseNote.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String,
//         isSynced = (map[isSyncedColumn] as int) == 1 ? true : false;

//   @override
//   String toString() => "Note, ID: $id, UserID: $userId, isSynced: $isSynced";

//   @override
//   bool operator ==(covariant DatabaseNote other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// const dbName = "Notes.db";
// const userTable = "user";
// const noteTable = "note";
// const idColumn = "id";
// const emailColumn = "email";
// const userIdColumn = "user_id";
// const textColumn = "text";
// const isSyncedColumn = "is_synced";
// const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
//   	    "id"	INTEGER NOT NULL,
// 	      "email"	TEXT NOT NULL UNIQUE,
// 	      PRIMARY KEY("id" AUTOINCREMENT)
//       ); ''';
// const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
// 	      "id"	INTEGER NOT NULL,
// 	      "user_id"	INTEGER,
// 	      "text"	TEXT,
// 	      "is_synced"	INTEGER NOT NULL DEFAULT 0,
// 	      FOREIGN KEY("user_id") REFERENCES "user"("id"),
// 	      PRIMARY KEY("id" AUTOINCREMENT)
//       ); ''';
