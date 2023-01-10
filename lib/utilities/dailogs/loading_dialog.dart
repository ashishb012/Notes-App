// import 'package:flutter/material.dart';

// typedef CloseDialog = void Function();

// CloseDialog showLoadingDailog({
//   required BuildContext context,
//   required String text,
// }) {
//   final dailog = AlertDialog(
//     content: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const CircularProgressIndicator(),
//         const SizedBox(height: 10.0),
//         Text(text),
//       ],
//     ),
//   );
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) => dailog,
//   );
//   //Navigator.of(context).pop();
//   return () => Navigator.of(context).pop();
// }
