import 'package:flutter/material.dart';
import 'package:ugbussinesscard/text_widget/text_src/option_button.dart';

class TextFormatTool extends StatelessWidget {
  final Function(
    bool bold,
    bool italic,
  ) onTextFormatEdited;
  final bool bold;
  final bool italic;
  final bool caps;

  const TextFormatTool({
    Key? key,
    required this.onTextFormatEdited,
    this.bold = false,
    this.italic = false,
    this.caps = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _TextFormatEditor(
            bold: bold,
            italic: italic,
            caps: caps,
            onFormatEdited: onTextFormatEdited,
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}

class _TextFormatEditor extends StatefulWidget {
  final Function(bool bold, bool italic) onFormatEdited;
  final bool bold;
  final bool italic;
  final bool caps;

  const _TextFormatEditor({
    required this.onFormatEdited,
    this.bold = false,
    this.italic = false,
    this.caps = false,
  });

  @override
  _TextFormatEditorState createState() => _TextFormatEditorState();
}

class _TextFormatEditorState extends State<_TextFormatEditor> {
  late bool _bold;
  late bool _italic;

  @override
  void initState() {
    _bold = widget.bold;
    _italic = widget.italic;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _TextFormatOption(
          title: 'BOLD',
          icon: Icons.format_bold,
          isActive: _bold,
          onPressed: () {
            setState(() => _bold = !_bold);
            widget.onFormatEdited(_bold, _italic);
          },
        ),
        _TextFormatOption(
          title: 'ITALIC',
          icon: Icons.format_italic,
          isActive: _italic,
          onPressed: () {
            setState(() => _italic = !_italic);
            widget.onFormatEdited(_bold, _italic);
          },
        ),
      ],
    );
  }
}

class _TextFormatOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onPressed;
  final bool isActive;

  const _TextFormatOption({
    required this.title,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OptionButton(
          isActive: isActive,
          onPressed: onPressed,
          child: Icon(icon),
        ),
        const SizedBox(height: 12),
        Text(title),
      ],
    );
  }
}
