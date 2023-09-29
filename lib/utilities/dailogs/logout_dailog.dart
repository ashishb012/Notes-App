import 'package:flutter/cupertino.dart';
import 'package:my_notes/utilities/dailogs/generic_dailogs.dart';

Future<bool> showLogoutDailog(BuildContext context) {
  return showGenericDailog<bool>(
    context: context,
    title: "Logout",
    content: "Are you sure you want to logout?",
    optionBuilder: () => {
      "Cancel": false,
      "Logout": true,
    },
  ).then((value) => value ?? false);
}
