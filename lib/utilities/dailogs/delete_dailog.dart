import 'package:flutter/cupertino.dart';
import 'package:my_notes/utilities/dailogs/generic_dailogs.dart';

Future<bool> showDeleteDailog(BuildContext context) {
  return showGenericDailog<bool>(
    context: context,
    title: "Delete Note",
    content: "Are you sure you want to delete this note?",
    optionBuilder: () => {
      "Cancel": false,
      "Delete": true,
    },
  ).then((value) => value ?? false);
}
