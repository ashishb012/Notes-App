import 'package:flutter/material.dart';

void showErrorDailog(
  BuildContext context,
  String text,
) {
  final snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
// // Add await everywhere it is used
// Future<void> showErrorDailog(
//   BuildContext context,
//   String text,
// ) {
// return showGenericDailog<void>(
//     context: context,
//     title: "An error occurred",
//     content: text,
//     optionBuilder: () => {
//       "Ok": null,
//     },
//   );
// }