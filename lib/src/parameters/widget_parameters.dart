import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gherkin/gherkin.dart';

class WidgetTypeParameter extends CustomParameter<Type> {
  WidgetTypeParameter([Transformer<Type>? transformer])
      : super('widget', RegExp(r'([A-Z][A-Za-z0-9$]+)'), (c) {
          switch (c.toLowerCase()) {
            case 'outlinedbutton':
              return OutlinedButton;
            case 'text':
              return Text;
            case 'textbutton':
              return TextButton;
            case 'iconbutton':
              return IconButton;
            case 'icon':
              return Icon;
            default:
              return transformer?.call(c);
          }
        });
}

class IconDataParameter extends CustomParameter<IconData> {
  IconDataParameter([Transformer<Type>? transformer])
      : super('icondata', RegExp(r'Icons\.([a-z][A-Za-z0-9$]+)'), (c) {
          switch (c.toLowerCase()) {
            case 'add':
              return Icons.add;
            case 'mic':
              return Icons.mic;
          }
          return null;
        });
}

class DoubleParameter extends CustomParameter<num> {
  DoubleParameter([Transformer<Type>? transformer])
      : super('num', RegExp(r'(-?)\d{1,4}\.\d{1,2}$'), (c) {
    switch (c.toLowerCase()) {
      case 'double':
        return double.tryParse(c);
    }
    return null;
  });
}

class ElementAnchorParameter extends CustomParameter<String> {
  ElementAnchorParameter()
      : super('anchor', RegExp(r'(first|last)'), (c) {
          return c;
        });
}
