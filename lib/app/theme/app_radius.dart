import 'package:flutter/widgets.dart';

/// Restrained radii keep surfaces calm and slightly architectural.
abstract final class AppRadius {
  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double full = 999;

  static const card = BorderRadius.all(Radius.circular(medium));
  static const control = BorderRadius.all(Radius.circular(small));
}
