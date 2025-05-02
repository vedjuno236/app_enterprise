import 'package:flutter/material.dart';

  Color getValueColor(String value) {
      if (value.startsWith('+')) {
        return Colors.green;
      } else if (value.startsWith('-')) {
        return Colors.red;
      } else {
        return Colors.black;
      }
    }