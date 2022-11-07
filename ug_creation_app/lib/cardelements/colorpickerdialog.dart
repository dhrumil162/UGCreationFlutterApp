import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

Future<ColorPicker> colorPicker(Color? pickerColor, BuildContext context,
    void Function(Color color) onColorChanged) async {
  return ColorPicker(
    color: pickerColor!,
    onColorChanged: (Color color) {
      onColorChanged(color);
    },
    width: 40,
    height: 40,
    borderRadius: 4,
    spacing: 5,
    runSpacing: 5,
    wheelDiameter: 155,
    heading: Text(
      'Select color',
      style: Theme.of(context).textTheme.subtitle1,
    ),
    subheading: Text(
      'Select color shade',
      style: Theme.of(context).textTheme.subtitle1,
    ),
    wheelSubheading: Text(
      'Selected color and its shades',
      style: Theme.of(context).textTheme.subtitle1,
    ),
    showColorName: true,
    materialNameTextStyle: Theme.of(context).textTheme.caption,
    colorNameTextStyle: Theme.of(context).textTheme.caption,
    colorCodeTextStyle: Theme.of(context).textTheme.bodyText2,
    colorCodePrefixStyle: Theme.of(context).textTheme.caption,
    selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
    pickersEnabled: const <ColorPickerType, bool>{
      ColorPickerType.both: true,
      ColorPickerType.primary: false,
      ColorPickerType.accent: false,
      ColorPickerType.wheel: true,
      ColorPickerType.custom: false,
    },
  );
}
