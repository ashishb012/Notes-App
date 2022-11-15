import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:my_notes/constants/routs.dart';
import 'package:my_notes/enums/menu_actions.dart';
import 'package:my_notes/services/auth/auth_services.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              switch (value) {
                case MenuAction.logout:
                  final bool isLogout = await logoutDailog(context);
                  if (isLogout) {
                    AuthService.firebase().logout();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.note_add_outlined),
      ),
    );
  }
}

Future<bool> logoutDailog(BuildContext context) => showDialog<bool>(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel")),
            TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Yes")),
          ],
        );
      }),
    ).then((value) => value ?? false);
