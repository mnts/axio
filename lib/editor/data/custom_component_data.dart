import 'dart:convert';

import 'package:flutter/material.dart';

class MyComponentFractal {
  Color color;
  Color borderColor;
  double borderWidth;

  String text;
  Alignment textAlignment = Alignment.center;
  double textSize;

  bool isHighlightVisible = false;

  MyComponentFractal({
    this.color = Colors.white,
    this.borderColor = Colors.black,
    this.borderWidth = 0.0,
    this.text = '',
    this.textAlignment = Alignment.center,
    this.textSize = 20,
  });

  MyComponentFractal.copy(MyComponentFractal customData)
      : this(
          color: customData.color,
          borderColor: customData.borderColor,
          borderWidth: customData.borderWidth,
          text: customData.text,
          textAlignment: customData.textAlignment,
          textSize: customData.textSize,
        );

  switchHighlight() {
    isHighlightVisible = !isHighlightVisible;
  }

  showHighlight() {
    isHighlightVisible = true;
  }

  hideHighlight() {
    isHighlightVisible = false;
  }

  Map<String, dynamic> toMap() {
    return {
      'color': color.value,
      'border_color': borderColor.value,
      'border_width': borderWidth,
      'text': text,
      //'text_alignment': textAlignment.toMap(),
      'text_size': textSize,
      'is_highlight_visible': isHighlightVisible,
    };
  }

  factory MyComponentFractal.fromMap(Map<String, dynamic> map) {
    return MyComponentFractal(
      color: Color(map['color']),
      borderColor: Color(map['border_color']),
      borderWidth: map['border_width']?.toDouble() ?? 0.0,
      text: map['text'] ?? '',
      //textAlignment: Alignment.fromMap(map['text_alignment']),
      textSize: map['text_size']?.toDouble() ?? 0.0,
      //isHighlightVisible: map['is_highlight_visible'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyComponentFractal.fromJson(String source) =>
      MyComponentFractal.fromMap(json.decode(source));
}
