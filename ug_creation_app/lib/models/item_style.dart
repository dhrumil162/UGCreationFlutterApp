import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ugbussinesscard/main.dart';

class ItemStyle {
  double? left;
  double? top;
  double? scale = 1;
  double? angle = 0.0;
  TextStyle? textStyle = TextStyle(
      fontFamily: "Open Sans",
      fontSize: 18,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 1,
      height: 1.2,
      color: Color(themeChangeProvider.darkTheme ? white.value : black.value));

  ItemStyle(this.left, this.top,
      {this.scale = 1,
      this.textStyle = const TextStyle(
          fontFamily: "Open Sans",
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          letterSpacing: 1,
          height: 1.2)});

  Map<String, dynamic> toJson() => {
        'left': left,
        'top': top,
        'scale': scale,
        'angle': angle,
        'color': textStyle?.color?.value ??
            (themeChangeProvider.darkTheme ? white.value : black.value),
        'fontWeight': textStyle?.fontWeight?.index,
        'fontStyle': textStyle?.fontStyle?.index,
        'fontSize': textStyle?.fontSize,
        'fontFamily': textStyle?.fontFamily,
        'letterSpacing': textStyle?.letterSpacing,
        'height': textStyle?.height
      };

  ItemStyle.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      top = json['top']?.toDouble();
      left = json['left']?.toDouble();
      scale = json['scale']?.toDouble();
      angle = json['angle']?.toDouble();
      textStyle = TextStyle(
          fontFamily: json["fontFamily"] ?? "Open Sans",
          fontSize: json["fontSize"]?.toDouble() ?? 18,
          letterSpacing: json["letterSpacing"] ?? 1,
          height: json["height"]?.toDouble() ?? 1.2,
          fontWeight: FontWeight.values[json["fontWeight"] ?? 3],
          fontStyle: FontStyle.values[json["fontStyle"] ?? 0],
          color: Color(json["color"] ??
              (themeChangeProvider.darkTheme ? white.value : black.value)));
    }
  }
}
