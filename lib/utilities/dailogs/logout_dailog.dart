import 'package:flutter/cupertino.dart';
import 'package:my_notes/utilities/dailogs/generic_dailogs.dart';

Future<bool> showLogoutDailog(BuildContext context) {
  return showGenericDailog<bool>(
    context: context,
    title: "LogOut",
    content: "Are you sure you want to logout?",
    optionBuilder: () => {
      "Cancel": false,
      "LogOut": true,
    },
  ).then((value) => value ?? false);
}
