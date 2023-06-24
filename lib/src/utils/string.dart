import 'package:flutter/material.dart';

extension FGTString on String {
  bool get isJson =>
      startsWith('{') && endsWith('}') || startsWith('[') && endsWith(']');

  String get trimQuotes {
    if (RegExp(r'''^["`'].*["`']$''').hasMatch(this)) {
      return substring(1, length - 1);
    }
    return this;
  }

  dynamic get value => num.tryParse(this) ?? trimQuotes;

  Type? get widgetType {
    switch(this) {
      case 'Text':
        return Text;
      case 'TextButton':
        return TextButton;
    }
    return null;
  }
}