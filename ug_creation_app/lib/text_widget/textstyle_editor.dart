// ignore_for_file: library_private_types_in_public_api

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'text_src/toolbar.dart';
import 'text_src/toolbar_action.dart';
import 'tools/font_family_tool.dart';
import 'tools/font_size_tool.dart';
import 'tools/text_format_tool.dart';

/// Text style editor
/// A flutter widget that edit text style and text alignment
///
/// You can pass your text style or alignment to the widget
/// and then get the edited text style
class TextStyleEditor extends StatefulWidget {
  /// Editor's font families
  final List<String> fonts;

  /// The text style
  final TextStyle textStyle;

  /// The inithial editor tool
  final EditorToolbarAction initialTool;

  /// [onTextStyleEdited] will be called after [textStyle] prop has changed
  final Function(TextStyle)? onTextStyleEdited;

  /// [onToolbarActionChanged] will be called after editor's tool has changed
  final Function(EditorToolbarAction)? onToolbarActionChanged;

  /// Create a [TextStyleEditor] widget
  ///
  /// [fonts] list of font families that you want to use in editor.
  /// [textStyle] initiate text style.
  /// [textAlign] initiate text alignment.
  ///
  /// [onTextStyleEdited] callback will be called every time [textStyle] has changed.
  const TextStyleEditor({
    Key? key,
    required this.fonts,
    required this.textStyle,
    this.initialTool = EditorToolbarAction.fontFamilyTool,
    this.onTextStyleEdited,
    this.onToolbarActionChanged,
  }) : super(key: key);

  @override
  _TextStyleEditorState createState() => _TextStyleEditorState();
}

class _TextStyleEditorState extends State<TextStyleEditor> {
  late EditorToolbarAction _currentTool;
  late TextStyle _textStyle;

  @override
  void initState() {
    _currentTool = widget.initialTool;
    _textStyle = widget.textStyle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Toolbar(
          initialTool: _currentTool,
          onToolSelect: (action) {
            setState(() => _currentTool = action);
            if (widget.onToolbarActionChanged != null) {
              widget.onToolbarActionChanged!(action);
            }
          },
        ),
        const Divider(),
        Expanded(
          child: SingleChildScrollView(
            child: () {
              // Choice tools
              switch (_currentTool) {
                case EditorToolbarAction.fontFamilyTool:
                  return FontFamilyTool(
                    fonts: widget.fonts,
                    selectedFont: _textStyle.fontFamily,
                    onSelectFont: (fontFamily) {
                      setState(() => _textStyle =
                          _textStyle.copyWith(fontFamily: fontFamily));

                      if (widget.onTextStyleEdited != null) {
                        widget.onTextStyleEdited!(_textStyle);
                      }
                    },
                  );
                case EditorToolbarAction.fontOptionTool:
                  return TextFormatTool(
                    bold: _textStyle.fontWeight == FontWeight.bold,
                    italic: _textStyle.fontStyle == FontStyle.italic,
                    onTextFormatEdited: (bold, italic) {
                      setState(() => _textStyle = _textStyle.copyWith(
                            fontWeight:
                                bold ? FontWeight.bold : FontWeight.normal,
                            fontStyle:
                                italic ? FontStyle.italic : FontStyle.normal,
                          ));

                      if (widget.onTextStyleEdited != null) {
                        widget.onTextStyleEdited!(_textStyle);
                      }
                    },
                  );
                case EditorToolbarAction.fontSizeTool:
                  return FontSizeTool(
                    fontSize: _textStyle.fontSize ?? 0,
                    letterHeight: _textStyle.height ?? 1.2,
                    letterSpacing: _textStyle.letterSpacing ?? 1,
                    onFontSizeEdited: (
                      fontSize,
                      letterSpacing,
                      letterHeight,
                    ) {
                      setState(() => _textStyle = _textStyle.copyWith(
                            fontSize: fontSize,
                            height: letterHeight,
                            letterSpacing: letterSpacing,
                          ));

                      if (widget.onTextStyleEdited != null) {
                        widget.onTextStyleEdited!(_textStyle);
                      }
                    },
                  );
                case EditorToolbarAction.fontColorTool:
                  return ColorPicker(
                    color: _textStyle.color ?? const Color(0xFF000000),
                    onColorChanged: (Color color) {
                      setState(
                          () => _textStyle = _textStyle.copyWith(color: color));
                      if (widget.onTextStyleEdited != null) {
                        widget.onTextStyleEdited!(_textStyle);
                      }
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
                    showColorName: false,
                    materialNameTextStyle: Theme.of(context).textTheme.caption,
                    colorNameTextStyle: Theme.of(context).textTheme.caption,
                    colorCodeTextStyle: Theme.of(context).textTheme.bodyText2,
                    colorCodePrefixStyle: Theme.of(context).textTheme.caption,
                    selectedPickerTypeColor:
                        Theme.of(context).colorScheme.primary,
                    pickersEnabled: const <ColorPickerType, bool>{
                      ColorPickerType.both: true,
                      ColorPickerType.primary: false,
                      ColorPickerType.accent: false,
                      ColorPickerType.wheel: true,
                      ColorPickerType.custom: false,
                    },
                  );
                default:
                  return Container();
              }
            }(),
          ),
        ),
      ],
    );
  }
}
