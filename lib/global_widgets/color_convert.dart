import 'package:flutter/material.dart';

Color hexToColor(String hex) {
  hex = hex.replaceAll('#', '');

  if (hex.length == 6) {
    hex = 'FF$hex';
  }

  // Convert the hex string to an integer and create a Color object
  return Color(int.parse(hex, radix: 16));
}