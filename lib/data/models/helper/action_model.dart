import 'package:flutter/material.dart';

class ActionModel {
  final IconData icon;
  final VoidCallback onPressed;

  ActionModel({
    required this.icon,
    required this.onPressed,
  });
}
