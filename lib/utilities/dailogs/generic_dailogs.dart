// use overlay later

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef DailogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDailog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DailogOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map(
          (optiontitle) {
            final T value = options[optiontitle];
            return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(optiontitle),
            );
          },
        ).toList(),
      );
    },
  );
}
