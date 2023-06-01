extension FGTString on String {
  bool get isJson =>
      startsWith('{') && endsWith('}') || startsWith('[') && endsWith(']');

  String get trimQuotes {
    if (RegExp(r'''^["`'].*["`']$''').hasMatch(this)) {
      return substring(1, length - 1);
    }
    return this;
  }

  dynamic get value => num.tryParse(this) ?? bool.tryParse(this) ?? trimQuotes;
}
