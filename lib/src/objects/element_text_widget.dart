import 'package:flutter/material.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';

/// Common widget for the element text
class ElementTextWidget extends StatefulWidget {
  ///
  const ElementTextWidget({
    required this.element,
    super.key,
  });

  ///
  final FlowElement element;

  @override
  State<ElementTextWidget> createState() => _ElementTextWidgetState();
}

class _ElementTextWidgetState extends State<ElementTextWidget> {
  final _textController = TextEditingController();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController
      ..text = widget.element.text
      ..addListener(() => widget.element.text = _textController.text);
    _titleController
      ..text = widget.element.title
      ..addListener(() => widget.element.title = _titleController.text);
    _subtitleController
      ..text = widget.element.subtitle
      ..addListener(() => widget.element.subtitle = _subtitleController.text);
  }

  @override
  Widget build(BuildContext context) {
    // If element has an image, show title and subtitle below
    if (widget.element.imageProvider != null) {
      return _buildTitleSubtitleWidget();
    }

    // If no image, show regular text inside element (centered)
    return _buildRegularTextWidget();
  }

  Widget _buildRegularTextWidget() {
    final textStyle = TextStyle(
      color: widget.element.textColor,
      fontSize: widget.element.textSize,
      fontWeight: widget.element.textIsBold ? FontWeight.bold : FontWeight.normal,
      fontFamily: widget.element.fontFamily,
    );

    Widget textWidget = widget.element.isEditingText
        ? TextFormField(
            controller: _textController,
            autofocus: true,
            onTapOutside: (event) => dismissTextEditor(),
            onFieldSubmitted: dismissTextEditor,
            textAlign: widget.element.textAlign,
            style: textStyle,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          )
        : Text(
            widget.element.text,
            textAlign: widget.element.textAlign,
            style: textStyle,
          );

    return Center(child: textWidget);
  }

  Widget _buildTitleSubtitleWidget() {
    final titleStyle = TextStyle(
      color: widget.element.titleColor,
      fontSize: widget.element.titleSize,
      fontWeight: widget.element.titleIsBold ? FontWeight.bold : FontWeight.normal,
      fontFamily: widget.element.fontFamily,
    );

    final subtitleStyle = TextStyle(
      color: widget.element.subtitleColor,
      fontSize: widget.element.subtitleSize,
      fontWeight: widget.element.subtitleIsBold ? FontWeight.bold : FontWeight.normal,
      fontFamily: widget.element.fontFamily,
    );

    return Positioned(
      top: widget.element.size.height + 10, // Position below the element
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          if (widget.element.title.isNotEmpty || widget.element.isEditingText)
            widget.element.isEditingText
                ? TextFormField(
                    controller: _titleController,
                    autofocus: true,
                    onTapOutside: (event) => dismissTextEditor(),
                    onFieldSubmitted: dismissTextEditor,
                    textAlign: widget.element.titleAlign,
                    style: titleStyle,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                    ),
                  )
                : Text(
                    widget.element.title,
                    textAlign: widget.element.titleAlign,
                    style: titleStyle,
                  ),
          // Subtitle
          if (widget.element.subtitle.isNotEmpty || widget.element.isEditingText)
            widget.element.isEditingText
                ? TextFormField(
                    controller: _subtitleController,
                    onTapOutside: (event) => dismissTextEditor(),
                    onFieldSubmitted: dismissTextEditor,
                    textAlign: widget.element.subtitleAlign,
                    style: subtitleStyle,
                    decoration: const InputDecoration(
                      hintText: 'Subtitle',
                      border: InputBorder.none,
                    ),
                  )
                : Text(
                    widget.element.subtitle,
                    textAlign: widget.element.subtitleAlign,
                    style: subtitleStyle,
                  ),
        ],
      ),
    );
  }

  void dismissTextEditor([String? text]) {
    if (text != null) widget.element.text = text;
    setState(() => widget.element.isEditingText = false);
  }
}
