// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/core/extension/extension_string.dart';
import 'package:flutter/material.dart';

class StringFormatter extends StatelessWidget {
  final String text;
  final double fontSize;
  final bool enableDiacritics;
  final Color? color;
  const StringFormatter({
    super.key,
    required this.text,
    required this.fontSize,
    required this.enableDiacritics,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(
      fontSize: fontSize,
      height: 2,
      color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
    );
    return RichText(
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
      text: customTextSpan(
        text: enableDiacritics ? text : text.removeDiacritics,
        defaultStyle: defaultStyle.copyWith(fontFamily: 'Kitab'),
        highlightStyle: defaultStyle.copyWith(fontFamily: 'Uthmanic2'),
      ),
    );
  }

  TextSpan customTextSpan({
    required String text,
    required TextStyle defaultStyle,
    required TextStyle highlightStyle,
  }) {
    final pattern = RegExp('﴿(.*?)﴾');
    final matches = pattern.allMatches(text);
    final List<TextSpan> children = [];

    int lastMatchEnd = 0;

    for (final match in matches) {
      final preMatch = text.substring(lastMatchEnd, match.start);
      final highlightedText = text.substring(match.start, match.end);

      if (preMatch.isNotEmpty) {
        children.add(TextSpan(text: preMatch, style: defaultStyle));
      }

      children.add(TextSpan(text: highlightedText, style: highlightStyle));

      lastMatchEnd = match.end;
    }

    final postMatch = text.substring(lastMatchEnd);
    if (postMatch.isNotEmpty) {
      children.add(TextSpan(text: postMatch, style: defaultStyle));
    }

    return TextSpan(children: children);
  }
}
