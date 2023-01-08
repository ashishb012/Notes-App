import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/constants/routs.dart';
import 'package:my_notes/enums/menu_actions.dart';
import 'package:my_notes/services/auth/auth_services.dart';
import 'package:my_notes/services/auth/bloc/auth_bloc.dart';
import 'package:my_notes/services/auth/bloc/auth_event.dart';
import 'package:my_notes/services/firebase_cloud/cloud_note.dart';
import 'package:my_notes/services/firebase_cloud/firebase_cloud_storage.dart';
import 'package:my_notes/utilities/dailogs/logout_dailog.dart';
import 'package:my_notes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesServices;
  String get userId => AuthService.firebase().currentUser!.id!;

  @override
  void initState() {
    super.initState();
    _notesServices = FirebaseCloudStorage();
  }

  //@override
  //void dispose() {
  //  _notesServices.close();
  //  super.dispose();
  //}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notes"),
          elevation: 5,
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            PopupMenuButton<MenuAction>(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<MenuAction>(
                    //value: MenuAction.,
                    child: Text("Option 1"),
                  ),
                  const PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text("Logout"),
                  ),
                ];
              },
              onSelected: (value) async {
                final logout = context.read<AuthBloc>();
                switch (value) {
                  case MenuAction.logout:
                    final bool isLogout = await showLogoutDailog(context);
                    if (isLogout) {
                      logout.add(const AuthEventLogOut());
                    }
                    log(value.toString());
                    log(isLogout.toString());
                }
              },
            ),
          ],
        ),
        drawer: Drawer(
          elevation: 2,
          child: ListView(
            padding: const EdgeInsets.only(top: 10, left: 5),
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(),
                child: Text("My Notes"),
              ),
              ListTile(
                title: const Text("Option 1"),
                onTap: () {
                  //
                  Navigator.of(context).pop();
                },
                onLongPress: () => const Text("Option 1"),
              ),
              ListTile(
                title: const Text("Option 2"),
                onTap: () {
                  //
                  Navigator.of(context).pop();
                },
                onLongPress: () => const Text("Option 2"),
              ),
              ListTile(
                title: const Text("Option 3"),
                onTap: () {
                  //
                  Navigator.of(context).pop();
                },
                onLongPress: () => const Text("Option 3"),
              ),
            ],
          ),
        ),
        body: StreamBuilder(
          stream: _notesServices.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;

                  return NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _notesServices.deletNote(
                        documentId: note.documentId,
                      );
                    },
                    onTap: (note) {
                      Navigator.of(context)
                          .pushNamed(createUpdateNotesRoute, arguments: note);
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(createUpdateNotesRoute);
          },
          child: const Icon(Icons.note_add_outlined),
        ),
      ),
    );
  }
}
