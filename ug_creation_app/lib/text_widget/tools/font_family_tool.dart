// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ugbussinesscard/text_widget/text_src/option_button.dart';

class FontFamilyTool extends StatefulWidget {
  final List<String> fonts;
  final Function(String) onSelectFont;
  final String? selectedFont;

  const FontFamilyTool({
    Key? key,
    required this.fonts,
    required this.onSelectFont,
    this.selectedFont,
  }) : super(key: key);

  @override
  _FontFamilyToolState createState() => _FontFamilyToolState();
}

class _FontFamilyToolState extends State<FontFamilyTool> {
  late String _selectedFont;

  @override
  void initState() {
    _selectedFont = widget.selectedFont ?? widget.fonts[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: widget.fonts
          .map<_FontFamily>(
            (font) => _FontFamily(
              font,
              isSelected: _selectedFont == font,
              onSelect: (selectedFont) {
                setState(() => _selectedFont = selectedFont);
                widget.onSelectFont(selectedFont);
              },
            ),
          )
          .toList(),
    );
  }
}

class _FontFamily extends StatelessWidget {
  final String font;
  final bool isSelected;
  final Function(String) onSelect;

  const _FontFamily(this.font,
      {required this.onSelect, this.isSelected = false});
  @override
  Widget build(BuildContext context) {
    return OptionButton(
      isActive: isSelected,
      size: Size(
          const Size.fromWidth(120).width, const Size.fromHeight(45).height),
      onPressed: () => onSelect(GoogleFonts.getFont(font).fontFamily ?? ""),
      child: Center(
          child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: const Size.fromWidth(10).width,
            vertical: const Size.fromHeight(10).height),
        child: Text(font,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: GoogleFonts.getFont(font).fontFamily)),
      )),
    );
  }
}
