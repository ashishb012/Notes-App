import 'package:flutter/material.dart';

void showCannotShareEmptyNoteDailog(BuildContext context) {
  const snackBar = SnackBar(
    content: Text("You cannot share an empty note!"),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
  // // Add await everywhere it is used
  // Future<void> showCannotShareEmptyNoteDailog(BuildContext context) {
  // return showGenericDailog<void>(
  //   context: context,
  //   title: "Sharing",
  //   content: "You cannot share an empty note!",
  //   optionBuilder: () => {
  //     "Ok": null,
  //   },
  // );
  // }
