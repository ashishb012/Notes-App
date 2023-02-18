import 'package:flutter/material.dart';

void showCannotShareEmptyNoteDailog(BuildContext context) {
  const snackbar = SnackBar(
    content: Text("You cannot share an empty note!"),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
  return;
}
  // showGenericDailog<void>(
  //   context: context,
  //   title: "Sharing",
  //   content: "You cannot share an empty note!",
  //   optionBuilder: () => {
  //     "Ok": null,
  //   },
  // );

