import 'package:flutter/material.dart';
import 'package:my_notes/utilities/dailogs/generic_dailogs.dart';

Future<void> showCannotShareEmptyNoteDailog(BuildContext context) {
  return showGenericDailog<void>(
    context: context,
    title: "Sharing",
    content: "You cannot share an empty note!",
    optionBuilder: () => {
      "Ok": null,
    },
  );
}
