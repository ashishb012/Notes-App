import 'package:flutter/material.dart' show immutable;

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadindScreenController {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadindScreenController({
    required this.close,
    required this.update,
  });
}
