import 'package:flutter/material.dart';
import 'package:my_notes/utilities/dailogs/generic_dailogs.dart';

Future<void> showPasswordResetEmailSentDailog(BuildContext context) async {
  await showGenericDailog<void>(
    context: context,
    title: "Password Reset",
    content:
        "We have sent a password reset. Please check your email for more information.",
    optionBuilder: () => {
      "Ok": null,
    },
  );
}
