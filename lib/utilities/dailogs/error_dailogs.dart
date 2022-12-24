import 'package:flutter/cupertino.dart';
import 'package:my_notes/utilities/dailogs/generic_dailogs.dart';

Future<void> showErrorDailog(
  BuildContext context,
  String text,
) {
  return showGenericDailog<void>(
    context: context,
    title: "An error occurred",
    content: text,
    optionBuilder: () => {
      "Ok": null,
    },
  );
}
