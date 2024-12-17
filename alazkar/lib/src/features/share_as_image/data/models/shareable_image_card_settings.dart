// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ShareableImageCardSettings extends Equatable {
  ///Image size
  final Size imageSize;
  final int charLengthPerSize;

  ///Text style
  final String mainFontFamily;
  final String secondaryFontFamily;

  const ShareableImageCardSettings({
    required this.imageSize,
    required this.charLengthPerSize,
    required this.mainFontFamily,
    required this.secondaryFontFamily,
  });

  const ShareableImageCardSettings.defaultSettings()
      : this(
          imageSize: const Size(1080, 1080),
          charLengthPerSize: 1500,
          mainFontFamily: "kitab",
          secondaryFontFamily: "kitab",
        );

  @override
  List<Object> get props => [
        imageSize,
        charLengthPerSize,
        mainFontFamily,
        secondaryFontFamily,
      ];

  ShareableImageCardSettings copyWith({
    Size? imageSize,
    int? charLengthPerSize,
    String? mainFontFamily,
    String? secondaryFontFamily,
  }) {
    return ShareableImageCardSettings(
      imageSize: imageSize ?? this.imageSize,
      charLengthPerSize: charLengthPerSize ?? this.charLengthPerSize,
      mainFontFamily: mainFontFamily ?? this.mainFontFamily,
      secondaryFontFamily: secondaryFontFamily ?? this.secondaryFontFamily,
    );
  }
}
